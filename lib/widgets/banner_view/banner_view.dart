import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/banner/ws_banner_info_res.dart';
import 'package:frechat/screens/app_web_view/app_web_view.dart';
import 'package:frechat/screens/profile/benefit/personal_benefit.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/widgets/banner_view/banner_view_model.dart';
import 'package:frechat/widgets/photo_view_gallery_alt/photo_view_gallery_alt.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../system/providers.dart';

class BannerView extends ConsumerStatefulWidget {

  // 放置頁面(0:全部 1:首頁 2:充值彈窗 3:消息頁面 4:通話頁面懸浮 5:我的頁面 6:首页悬浮)
  // 此參數只有填 1 ~ 6 才有意義，0 基本上不產生作用，因為 locatedPage = 0 必定顯示
  // 這邊命名太麻煩，也不容易理解，就不做 enum 處理了。
  final int locatedPageFilter;

  //顯示比例, 目前有三種狀況
  //A. Icon size: 1 x 1 = 1
  //B. Full screen dialog: 1 x 1 = 1
  //B. 橫向條狀: 343 x 100 = 3.43
  final double aspectRatio;

  //是否自動輪播
  final bool autoPlay;

  //留邊
  final EdgeInsets padding;

  //圓角程度
  final double borderRadius;

  //頁面指示器靠下距離
  final double pageIndicatorBottomPadding;

  //頁面指示器縮放
  final double pageIndicatorScale;

  final bool reserveSpot;

  final bool inAppWebView;

  const BannerView({
    super.key,
    this.locatedPageFilter = 1,
    this.aspectRatio = 1,
    this.autoPlay = true,
    this.padding = const EdgeInsets.all(8),
    this.borderRadius = 12,
    this.pageIndicatorBottomPadding = 8,
    this.pageIndicatorScale = 1,
    this.reserveSpot = true,
    this.inAppWebView = false,
  });

  @override
  ConsumerState<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends ConsumerState<BannerView> {
  //For PhotoView
  //Note this should be infinite.
  int _currentPageIndex = 100;
  final PageController _photoViewPageController = PageController(initialPage: 100);

  //Loop through all banners in every 3 seconds.
  Timer? _autoPlayTimer;
  late BannerViewModel viewModel;
  late AppTheme appTheme;
  late AppColorTheme appColorTheme;

  @override
  void initState() {
    super.initState();
    viewModel = BannerViewModel(ref: ref, setState: setState);
    viewModel.init();

    //Start the auto play timer?
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _nextBanner();
    });
  }

  @override
  void dispose() {
    viewModel.dispose();
    _autoPlayTimer?.cancel();
    super.dispose();
  }

  void _resetTimer() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _nextBanner();
    });
  }

  void _nextBanner() {
    if (widget.autoPlay) {
      //Find the next page index.
      List<BannerInfo> displayingBannerInfo = _filteredBannerInfoList();
      if (displayingBannerInfo.length > 1) {
        int nextPage = _currentPageIndex + 1;
        _photoViewPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 330),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  //根據現有的 WsBannerInfoRes.list 內過濾出符合條件需要顯示的 BannerInfo 們
  List<BannerInfo> _filteredBannerInfoList() {
    List<BannerInfo> returnList = filterBannerView();
    return returnList;
  }

  List<BannerInfo> filterBannerView() {
    WsBannerInfoRes? bannerInfoRes = ref.read(userUtilProvider).bannerInfo;
    num? personalGender = ref.read(userUtilProvider).memberInfo?.gender;
    num depositCount = ref.read(userUtilProvider).memberPointCoin?.depositCount ?? 0;
    final regTime = ref.read(userUtilProvider).memberInfo?.regTime;

    // 檢查這個 bannerInfo 是否合法
    if (bannerInfoRes == null) return [];

    List<BannerInfo> validList = bannerInfoRes.list!.where((bannerInfo) {
      // 濾掉狀態是關閉的
      if (bannerInfo.status != 0) {
        return false;
      }

      // 檢查 "現在時間" 是否有在時間區間內
      if (bannerInfo.startTime != null && bannerInfo.endTime != null) {
        // 檢查活动时间
        DateTime startDateTime = DateTime.fromMillisecondsSinceEpoch(bannerInfo.startTime as int);
        DateTime endDateTime = DateTime.fromMillisecondsSinceEpoch(bannerInfo.endTime as int);

        // 不在時限內，未開始或者已過期．
        if (DateTime.now().isAfter(endDateTime) || DateTime.now().isBefore(startDateTime)) {
          return false;
        }
      }

      // 檢查是不是灰度設置
      if (bannerInfo.targetPeople == 1) {

        num? greyZoneSex = bannerInfo.greyZoneSex;
        num? greyRegisterTime = bannerInfo.greyRegisterTime;
        num? greyRegisterEndTime = bannerInfo.greyRegisterEndTime;
        num? greyRecharge = bannerInfo.greyRecharge;

        // 如果 greyZoneSex 不等於 0 && greyZoneSex 不等於自己性別
        // greyZoneSex (0:全部 1:男性 2:女性)
        if (greyZoneSex != 0) {
          num gender = personalGender == 0 ? 2 : 1;
          if (greyZoneSex != gender) return false;
        }

        // 檢查 "註冊時間" 是否有在時間區間內
        if (greyRegisterTime != null && greyRegisterEndTime != null) {
          DateTime regDateTime = DateTime.fromMillisecondsSinceEpoch(regTime as int);
          DateTime greyZoneStartDateTime = DateTime.fromMillisecondsSinceEpoch(greyRegisterTime as int);
          DateTime greyZoneEndDateTime = DateTime.fromMillisecondsSinceEpoch(greyRegisterEndTime as int);
          // 不在時限內，未開始或者已過期 ．
          if (regDateTime.isAfter(greyZoneEndDateTime) || regDateTime.isBefore(greyZoneStartDateTime)) return false;
        }

        if (greyRecharge != 0 && greyRecharge == 1 && depositCount >= 1) return false;
        if (greyRecharge != 0 && greyRecharge == 2 && depositCount < 1) return false;

      }

      // 所屬頁面過濾
      if (bannerInfo.locatedPage != 0 && bannerInfo.locatedPage != widget.locatedPageFilter) {
        return false;
      }

      // 防呆
      if (bannerInfo.activityBanner == null || bannerInfo.activityBanner!.isEmpty) {
        return false;
      }

      return true;
    }).toList();

    return validList;
  }

  @override
  Widget build(BuildContext context) {
    appTheme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appColorTheme = appTheme.getAppColorTheme;
    //這邊動態產生 imageProviders, 依據 _filteredBannerInfoList
    List<BannerInfo> displayingBannerInfo = _filteredBannerInfoList();
    //這邊我們就用 photoView 來處理
    return (displayingBannerInfo.isNotEmpty)
        ? AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: ClipRect(
              child: Visibility(
                visible: displayingBannerInfo.isNotEmpty,
                child: _contentWidget(displayingBannerInfo),
              ),
            ),
          )
        : Container();
  }

  Widget _contentWidget(List<BannerInfo> displayingBannerInfo) {
    List<ImageProvider> imageProviders = displayingBannerInfo
        .map((e) => CachedNetworkImageProvider(HttpSetting.baseImagePath + e.activityBanner!))
        .toList();

    //Viewer 主體
    return GestureDetector(
      onTap: () async {
        //Open the Link of the current index.
        if (_currentPageIndex >= 0) {
          if (widget.inAppWebView) {
            if (displayingBannerInfo[_currentPageIndex % displayingBannerInfo.length].activityLink == 'ios_credit_exchange') {
              BaseViewModel.pushPage(context, PersonalBenefit(isFromBannerView: true));
              return;
            }

            final Uri uri = Uri.parse(displayingBannerInfo[_currentPageIndex % displayingBannerInfo.length].activityLink!);
            final Uri webUri = viewModel.getLaunchUrl(uri);
            BaseViewModel.pushPage(
                context,
                AppWebView(
                    title: displayingBannerInfo[_currentPageIndex % displayingBannerInfo.length].activityName ?? '',
                    webUri: webUri.toString()
                ));
            return;
          }
          final Uri uri = Uri.parse(displayingBannerInfo[_currentPageIndex % displayingBannerInfo.length].activityLink!);
          if (await canLaunchUrl(uri)) {
            viewModel.launch(uri);
          }
        }
      },
      onTapDown: (TapDownDetails details) {
        //Reset Timer when any input detected.
        _resetTimer();
      },
      child: Padding(
        padding: widget.padding,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Stack(
            alignment: Alignment.center,
            children: [
              PhotoViewGalleryAlt.builder(
                backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                scrollPhysics: const BouncingScrollPhysics(),
                allowImplicitScrolling: true,
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    //Check if the link has already been downloaded. (has a fullImageRawInfo data)
                    imageProvider: imageProviders[index % imageProviders.length],
                    initialScale: PhotoViewComputedScale.covered,
                    tightMode: true,
                    minScale: PhotoViewComputedScale.covered,
                    maxScale: PhotoViewComputedScale.covered,
                    disableGestures: true,
                  );
                },
                loadingBuilder: (context, event) => Center(
                  child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      color: appColorTheme.bannerIndicatorColor,
                      value: event == null || event.expectedTotalBytes == null || event.expectedTotalBytes == 0
                          ? 0
                          : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                    ),
                  ),
                ),
                pageController: _photoViewPageController,
                onPageChanged: _onPhotoViewerPageChanged,
              ),

              //Page indicator.
              Positioned(
                bottom: widget.pageIndicatorBottomPadding,
                child: Visibility(
                  visible: imageProviders.length > 1,
                  child: Transform.scale(
                    scale: widget.pageIndicatorScale,
                    child: SmoothPageIndicator(
                      controller: _photoViewPageController,
                      count: imageProviders.length,
                      effect: WormEffect(
                        activeDotColor: appColorTheme.bannerIndicatorColor,
                        dotWidth: 8,
                        dotHeight: 8,
                      ),
                      onDotClicked: (index) {
                        //Do nothing.
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onPhotoViewerPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }
}
