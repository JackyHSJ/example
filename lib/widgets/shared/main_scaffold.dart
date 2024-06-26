import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';


import '../constant_value.dart';


class MainScaffold extends ConsumerStatefulWidget {
  MainScaffold(
      {super.key, this.enableBackGesture = false,
      this.isFullScreen = false,
      this.margin,
      this.needSingleScroll = true,
      this.padding,
      this.appBar,
      this.viewDidDisappear,
      this.viewDidAppear,
      this.backgroundColor = AppColors.globalBackGround,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.needBackground = false,
      this.resizeToAvoidBottomInset= false,
      this.needVagueBackground= false,
      this.vagueBackgroundImage,
      required this.child});

  bool enableBackGesture;
  EdgeInsetsGeometry? margin;
  bool isFullScreen;
  final EdgeInsetsGeometry? padding;
  dynamic appBar;
  Function()? viewDidDisappear;
  Function()? viewDidAppear;
  Widget child;
  bool needSingleScroll;
  Color backgroundColor;
  Widget? floatingActionButton;
  FloatingActionButtonLocation? floatingActionButtonLocation;
  bool needBackground;
  bool needVagueBackground;
  String? vagueBackgroundImage;
  bool resizeToAvoidBottomInset;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  bool? get enableBackGesture => widget.enableBackGesture;

  Widget get child => widget.child;

  get appBar => widget.appBar;

  bool get isFullScreen => widget.isFullScreen;

  bool get needSingleScroll => widget.needSingleScroll;

  Color get backgroundColor => widget.backgroundColor;

  Widget? get floatingActionButton => widget.floatingActionButton;

  FloatingActionButtonLocation? get floatingActionButtonLocation => widget.floatingActionButtonLocation;

  bool get needBackground => widget.needBackground;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppImageTheme appImageTheme = theme.getAppImageTheme;
    return Scaffold(
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      extendBodyBehindAppBar: true,
      backgroundColor: backgroundColor,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation ?? FloatingActionButtonLocation.centerDocked,
      body: needSingleScroll ? FocusDetector(
        onFocusLost: () => (widget.viewDidDisappear == null)
            ? null
            : widget.viewDidDisappear!(),
        onFocusGained: () => (widget.viewDidAppear == null)
            ? null
            : widget.viewDidAppear!(),
        child: Stack(
          children: [
            (widget.needVagueBackground)?(widget.vagueBackgroundImage!.contains('assets'))?Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.vagueBackgroundImage ?? ''),
                    fit: BoxFit.cover,
                  )
              ),
            ):Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.vagueBackgroundImage ?? ''),
                      fit: BoxFit.cover,
                    ))):Container(),
            (widget.needVagueBackground)?BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0),
              )):Container(),
            Container(
                decoration: needBackground ? (appImageTheme.personalTabBackground.isNotEmpty)?BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(appImageTheme.personalTabBackground),
                    fit: BoxFit.cover,
                  ),
                ):null : null,
                // decoration: BoxDecoration(
                //     image: DecorationImage(
                //         image: AssetImage(widget.setBGImg ??
                //             (widget.isBackground1
                //                 ? AppImagePath.backgroundLight
                //                 : AppImagePath.backgroundTrans)),
                //         fit: widget.notCareHeight
                //             ? BoxFit.fitHeight
                //             : BoxFit.scaleDown)),
                margin: widget.margin,
                padding: widget.padding ??
                    EdgeInsets.only(
                        left: WidgetValue.horizontalPadding,
                        right: WidgetValue.horizontalPadding,
                        top: WidgetValue.topPadding),
                width: UIDefine.getWidth(),
                height: _setHeight(isFullScreen, appBar == null),
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! >= 10 &&
                        enableBackGesture == true) {
                      BaseViewModel.popPage(context);
                    }
                  },
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => BaseViewModel.clearAllFocus(),
                      child: child,
                    ),
                  ),
                ))
          ],
        ),
      )
          : FocusDetector(
              onFocusLost: () => (widget.viewDidDisappear == null)
                  ? null
                  : widget.viewDidDisappear!(),
              onFocusGained: () => (widget.viewDidAppear == null)
                  ? null
                  : widget.viewDidAppear!(),
              child: Container(
                margin: widget.margin,
                  // decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: widget.isBackground1
                  //             ? const AssetImage(AppImagePath.backgroundLight)
                  //             : const AssetImage(AppImagePath.backgroundTrans),
                  //         fit: BoxFit.scaleDown)),
                  padding: widget.padding ??
                      EdgeInsets.only(
                          left: WidgetValue.horizontalPadding,
                          right: WidgetValue.horizontalPadding,
                          top: WidgetValue.topPadding),
                  width: MediaQuery.of(context).size.width,
                  height: _setHeight(isFullScreen, appBar == null),
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity! >= 10 &&
                          enableBackGesture == true) {
                        BaseViewModel.popPage(context);
                      }
                    },
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => BaseViewModel.clearAllFocus(),
                      child: child,
                    ),
                    // child: child,
                  )),
            ),
    );
  }

  _setHeight(bool isFull, bool isAppBar) {
    if (isFull) {
      return MediaQuery.of(context).size.height;
    } else {
      // return UIDefine.getHeight() -
      //     WidgetValue.topPadding -
      //     WidgetValue.navigationBarHeight;
    }
  }
}
