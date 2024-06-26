import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/custom_route/transparent_route.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'dart:core';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'profile/edit/personal_edit_view_model.dart';


//The args for this view.
class ImageLinksViewerArgs {
  //說是 links 但是其實是 EditImgModel / url path / ImageProvider
  final List<dynamic> imageLinks;
  final int initialPage;
  bool? transparentBackground;

  ImageLinksViewerArgs({required this.imageLinks, required this.initialPage, this.transparentBackground = false});
}

class ImageLinksViewer extends ConsumerStatefulWidget {
  static void show(BuildContext context, ImageLinksViewerArgs args) {
    //Nope: this will cause a bit glitch.
    //  SystemChrome.setEnabledSystemUIOverlays([]);
    Navigator.push(context, TransparentRoute(builder: (BuildContext context) {
      return ImageLinksViewer(args);
    }));
  }


  ImageLinksViewer(this.args, {super.key})
      : pageController = PageController(initialPage: args.initialPage);

  final ImageLinksViewerArgs args;
  final PageController pageController;

  @override
  ConsumerState<ImageLinksViewer> createState() => _ImageLinksViewerState();
}

class _ImageLinksViewerState extends ConsumerState<ImageLinksViewer> {
  _ImageLinksViewerState();

  //Allow close image gesture only when the scale state is initial.
  PhotoViewScaleState _currentScaleState = PhotoViewScaleState.initial;

  static const double VIRTUAL_MAX_VERTICAL_DRAG_OFFSET = 150.0;
  static const double GESTURE_SENSITIVITY_TO_CLOSE = 50.0;

  Offset _translateOffset = const Offset(0, 0);
  int _frontLayerOpacity = 1;
  int _currentPageIndex = 0;
  late AppTheme _theme;


  @override
  void initState() {
    HapticFeedback.lightImpact();
    super.initState();
    _currentPageIndex = widget.args.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.mainBlack,
        appBar:  MainAppBar(theme:_theme,title: '', backgroundColor: AppColors.whiteBackGround,),
        body: SafeArea(
          child: Stack(
            children: [
              //PhotoViewer.
              GestureDetector(
                onVerticalDragUpdate: _currentScaleState == PhotoViewScaleState.initial ? (details) {
                  //Let's try this...
                  //A magic way to scale the delta by current offset rate to GESTURE_SENSITIVITY_TO_CLOSE
                  double deltaScale = 1 -
                      (_translateOffset.dy.abs() /
                          VIRTUAL_MAX_VERTICAL_DRAG_OFFSET);
                  setState(() {
                    _translateOffset =
                        details.delta * deltaScale + _translateOffset;
                  });
                } : null,
                onVerticalDragEnd: _currentScaleState == PhotoViewScaleState.initial ? (details) {
                  // print('onVerticalDragEnd');

                  //Check the offset to see if we should close the viewer.
                  if (_translateOffset.dy.abs() >=
                      GESTURE_SENSITIVITY_TO_CLOSE) {

                    HapticFeedback.lightImpact();

                    Navigator.pop(context);
                  } else {
                    //Transform back to center.
                    setState(() {
                      _translateOffset = const Offset(0, 0);
                    });
                  }
                } : null,
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    if (_frontLayerOpacity != 0) {
                      _frontLayerOpacity = 0;
                    } else {
                      _frontLayerOpacity = 1;
                    }
                  });
                },
                child: Transform.translate(
                  offset: _translateOffset,
                  child: PhotoViewGallery.builder(
                    backgroundDecoration:
                    const BoxDecoration(color: Colors.transparent),
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (BuildContext context, int index) {

                      //Support the dynamic type.
                      ImageProvider? imageProvider;
                      String? heroTag;
                      if (widget.args.imageLinks[index] is EditImgModel) {
                        imageProvider = widget.args.imageLinks[index].getImageProvider();
                        heroTag = widget.args.imageLinks[index].getHeroTag();
                      } else if (widget.args.imageLinks[index] is ImageProvider) {
                        imageProvider = widget.args.imageLinks[index];
                      } else if (widget.args.imageLinks[index] is String) {
                        imageProvider = CachedNetworkImageProvider(widget.args.imageLinks[index]);
                      }

                      return PhotoViewGalleryPageOptions(
                        //Check if the link has already been downloaded. (has a fullImageRawInfo data)
                        imageProvider: imageProvider,
                        initialScale: PhotoViewComputedScale.contained,
                        heroAttributes: heroTag != null ? PhotoViewHeroAttributes(
                            tag: heroTag) : null,
                        tightMode: true,
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.contained * 10.0,
                      );
                    },
                    itemCount: widget.args.imageLinks.length,
                    loadingBuilder: (context, event) => Center(
                      child: SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          value: event == null || event.expectedTotalBytes == null || event.expectedTotalBytes == 0
                              ? 0
                              : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes!,
                        ),
                      ),
                    ),
                    pageController: widget.pageController,
                    onPageChanged: _onViewerPageChanged,
                    scaleStateChangedCallback: _onViewerScaleStateChanged,
                  ),
                ),
              ),

              //Front layer to display a back arrow button on the left top.
              AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: _frontLayerOpacity.toDouble(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //The upper left arrow bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      height: kToolbarHeight,
                      child: Row(
                        children: [
                          //Arrow button
                          Visibility(
                            visible: widget.args.transparentBackground == false,
                            child: IconButton(
                                padding: const EdgeInsets.only(bottom: 2),
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.pop(context);
                                }),
                          ),
                          //Options button, (Maybe not)
                          // PopupMenuButton<String>(
                          //     onSelected: _onPopupSelected,
                          //     itemBuilder: (context) {
                          //       return [
                          //         menuItem('Share Link', Icons.share, 'Share Link'),
                          //         menuItem('Copy Link', Icons.copy, 'Copy Link'),
                          //         menuItem('Save', Icons.save_alt, 'Save'),
                          //       ];
                          //     }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    //Hide the indicator if only one link is provided.
                    Visibility(
                      visible: widget.args.imageLinks.length > 1,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: SmoothPageIndicator(
                          controller: widget.pageController,
                          count: widget.args.imageLinks.length,
                          effect: const WormEffect(
                            activeDotColor: AppColors.mainPink,
                            dotWidth: 8,
                            dotHeight: 8,
                          ),
                          onDotClicked: (index) {
                            //Do nothing.
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: kMinInteractiveDimension,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // PopupMenuItem<String> menuItem(String value, IconData icon, String text) {
  //   return PopupMenuItem(
  //     value: value,
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Icon(
  //           icon,
  //           color: Theme.of(context).iconTheme.color,
  //         ),
  //         const SizedBox(
  //           width: 8,
  //         ),
  //         Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 5), child: Text(text)),
  //       ],
  //     ),
  //   );
  // }

  _onViewerPageChanged(int index) {
    // print('_onViewerPageChanged: ' + index.toString());
    setState(() {
      _currentScaleState = PhotoViewScaleState.initial;
    });

    _currentPageIndex = index;
  }

  _onViewerScaleStateChanged(PhotoViewScaleState state) {
    // print('_onViewerScaleStateChanged: ' + state.toString());
    setState(() {
      _currentScaleState = state;
    });
  }

  // _onPopupSelected(String value) async {
  //   switch (value) {
  //     case 'Share Link':
  //       HapticFeedback.lightImpact();
  //       if (_currentPageIndex >= 0 &&
  //           _currentPageIndex < widget.args.imageLinks.length) {
  //         Share.share(
  //             widget.args.imageLinks[_currentPageIndex].getFullImageUrl());
  //       }
  //       break;
  //     case 'Copy Link':
  //       HapticFeedback.lightImpact();
  //       FlutterClipboard.copy(widget.args.imageLinks[_currentPageIndex].getFullImageUrl());
  //       _showFlushBar(context, Icons.content_copy, 'Link copied.');
  //       break;
  //     case 'Save':
  //       HapticFeedback.lightImpact();
  //       if (_currentPageIndex >= 0 &&
  //           _currentPageIndex < widget.args.imageLinks.length) {
  //         String imageUrl =
  //         widget.args.imageLinks[_currentPageIndex].getFullImageUrl();
  //
  //         File cachedFile = await DefaultCacheManager().getSingleFile(imageUrl);
  //         if (cachedFile != null) {
  //           // int fileSize = await cachedFile.length();
  //           // print('Got file size: [' + fileSize.toString() + ']');
  //
  //           PermissionStatus status = await Permission.storage.status;
  //           if (!status.isGranted) {
  //             status = await Permission.storage.request();
  //           }
  //
  //           if (status.isGranted) {
  //             Uri imageUri = Uri.parse(imageUrl);
  //             Map<dynamic, dynamic> saveResult =
  //             await ImageGallerySaver.saveImage(
  //                 cachedFile.readAsBytesSync(),
  //                 quality: 100,
  //                 name: imageUri.pathSegments.last);
  //
  //             if (saveResult != null && saveResult['isSuccess'] == true) {
  //               _showFlushBar(context, Icons.save_alt, 'File Saved!');
  //             }
  //           } else {
  //             _showFlushBar(context, Icons.warning, 'Permission denied.');
  //           }
  //
  //           // if (status.isGranted) {
  //           //
  //           //   if (Platform.isAndroid) {
  //           //     //Save the file...
  //           //     String picturesPath = await AndroidPathProvider.picturesPath;
  //           //     String urlFileName = widget.args.imageLinks[_currentPageIndex].getFullImageFileName();
  //           //     if (picturesPath != null) {
  //           //       Directory targetDir = await Directory(picturesPath + '/BahKutTeh').create();
  //           //       if (targetDir != null) {
  //           //         File copiedFile = await cachedFile.copy(targetDir.path + '/' + urlFileName);
  //           //         print('copy file[' + targetDir.path + '/' + urlFileName + ']');
  //           //         if (copiedFile != null) {
  //           //           _showFlushBar(context, Icons.save_alt, 'File Saved!', targetDir.path + '/' + urlFileName);
  //           //         } else {
  //           //           _showFlushBar(context, Icons.warning, 'Oops!', 'Copy file failed!');
  //           //         }
  //           //       } else {
  //           //         _showFlushBar(context, Icons.warning, 'Oops!', 'Create directory failed!');
  //           //       }
  //           //     } else {
  //           //       _showFlushBar(context, Icons.warning, 'Oops!', 'Cannot get the directory.');
  //           //     }
  //           //   } else if (Platform.isIOS) {
  //           //     //Todo
  //           //   }
  //           // } else {
  //           //   _showFlushBar(context, Icons.warning, 'Oops!', 'Permission denied.');
  //           // }
  //         } else {
  //           // print('Oops! cachedFile is null!');
  //           _showFlushBar(context, Icons.warning,
  //               'Waiting for the file. Try again later.');
  //         }
  //       }
  //       break;
  //   }
  // }

}
