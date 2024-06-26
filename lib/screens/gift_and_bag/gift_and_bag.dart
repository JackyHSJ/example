
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/account/ws_account_call_package_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_gift_detail_res.dart';
import 'package:frechat/screens/gift_and_bag/gift_and_bag_viewmodel.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/widgets/customunderlinetabindicator.dart';
import 'package:frechat/widgets/shared/bottom_sheet/recharge/recharge_bottom_sheet.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/inappweb.dart';
import 'package:frechat/widgets/shared/tab_bar/main_tab_bar.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class GiftAndBag extends ConsumerStatefulWidget {
  const GiftAndBag({Key? key,required this.onTapSendGift}) : super(key: key);

  final Function(GiftListInfo result) onTapSendGift;

  @override
  ConsumerState<GiftAndBag> createState() => _GiftAndBagState();
}

class _GiftAndBagState extends ConsumerState<GiftAndBag>
    with SingleTickerProviderStateMixin {
  String giveGiftNum = "0";
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  // bool showCustomTextField = false;
  bool doNotShowTextField = true;
  double keyboardHight = 0;
  late GiftAndBagViewModel viewModel;
  bool autofocus = false;
  FocusNode _focusNode = FocusNode();
  GiftListInfo? chooseGiftListInfo;
  FreBackPackListInfo? chooseFreBackPackListInfo;
  String bannerUrl = '';
  String activityLink = '';
  late AppTheme _theme;
  late AppColorTheme appColorTheme;
  late AppImageTheme appImageTheme;
  late AppLinearGradientTheme appLinearGradientTheme;


  @override
  void initState() {
    super.initState();
    viewModel = GiftAndBagViewModel(ref: ref, setState: setState, context: context, tickerProvider: this);
    viewModel.initGiftCategory();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appColorTheme = _theme.getAppColorTheme;
    appImageTheme = _theme.getAppImageTheme;
    appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    return (viewModel.giftCategoryLoading) ?loadingWidget(): contentWidget();
  }

  Widget loadingWidget(){
    return  _buildLoadingIndicator();
  }

  Widget contentWidget(){
    return  Stack(
      children: [
        bannerWidget(),
        Container(
          margin: EdgeInsets.only(top: 42.h),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child:SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildTabBar(),
                ),
                Expanded(
                  child: TabBarView(
                    controller: viewModel.tabController,
                    children: viewModel.tabDataList
                        .map((tabData) =>
                        Center(child: tabContentWidget(tabData.data)))
                        .toList(),
                  ),
                ),
                Container(
                  height: 68.h,
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      rechargeWidget(),
                      giftGivingWidget()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            child: Offstage(
              offstage: doNotShowTextField,
              child: Container(
                  height: 52.h,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customNumberTextField(),
                      customNumberTextFieldOkButton()
                    ],
                  ),
              ),
            ))
      ],
    );
  }

  Widget _buildTabBar() {
    return MainTabBar(
      controller: viewModel.tabController,
      tabList: viewModel.tabDataList.map((tabData) => Tab(text: tabData.title)).toList()).tabBar(
      isScrollable: true,
      unSelectTextStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
        color: const Color.fromRGBO(153, 153, 153, 1),
      ),
      selectTextStyle: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 18.sp,
        decoration: TextDecoration.none,
        color: Colors.white,
      ),
      indicator: CustomUnderlineTabIndicator(color: appColorTheme.tabBarIndicatorColor),
      tabAlignment: TabAlignment.start
    );
  }

  Widget bannerWidget(){
    return (bannerUrl.isNotEmpty)
    ? Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  width: 126.w,
                  height: 42.h,
                  child: CachedNetworkImageUtil.load(
                      HttpSetting.baseImagePath + bannerUrl)),
              onTap: () {
                showBottomSheetWebview();
              },
            ),
          )
        : Container();
  }

  void showBottomSheetWebview(){
    double bottomSheeHeight = UIDefine.getHeight()*3/4;
    showModalBottomSheet<dynamic>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (BuildContext context) {
        return Container(
            height: bottomSheeHeight,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: InAppWebViewBrowser(url: activityLink)
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  //自訂數量TextField
  Widget customNumberTextField() {
    return Container(
      margin: EdgeInsets.only(left: 16.w),
      width: 270.w,
      height: 36.h,
      child: TextField(
        controller: textEditingController,
        autofocus: autofocus,
        decoration: InputDecoration(
          hintText: '请输入数量',
          hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.mainGrey),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          contentPadding: EdgeInsets.only(left: 16.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(3)
        ],
        style: TextStyle(fontSize: 14.sp, color: Colors.black),
        keyboardType: TextInputType.number,
        onSubmitted: (text) {
          setState(() {
            // showCustomTextField = false;
            // giveGiftNum = textEditingController.text;
          });
        },
      ),
    );
  }

  //自訂數量TextField旁邊確認按鈕
  Widget customNumberTextFieldOkButton() {
    return GestureDetector(
      child: Container(
        height: 36.w,
        width: 64.h,
        margin: EdgeInsets.only(right: 16.w),
        alignment: const Alignment(0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: AppColors.pinkLightGradientColors,
        ),
        child: Text(
          "确定",
          style: TextStyle(fontSize: 12.sp, color: Colors.white),
        ),
      ),
      onTap: () {
        setState(() {
          doNotShowTextField = true;
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          giveGiftNum = textEditingController.text;
        });
      },
    );
  }

  //GridView內容
  Widget tabContentWidget(dynamic res) {
    // print(getGiftDetailRes);
    List<Widget> widgetList = [];
    if (res is WsAccountGetGiftDetailRes) {
      WsAccountGetGiftDetailRes getGiftDetailRes = res;
      if (getGiftDetailRes.giftList!.isNotEmpty) {
        for (int i = 0; i < getGiftDetailRes.giftList!.length; i++) {
          widgetList.add(giftAndPriceWidget(getGiftDetailRes.giftList![i]));
        }
        List<Widget> resverwidgetList = widgetList.reversed.toList();
        return GridView.count(
            crossAxisCount: 4,
            mainAxisSpacing: 30,
            crossAxisSpacing: 8,
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            childAspectRatio: 0.7,
            children: resverwidgetList);
      } else {
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ImgUtil.buildFromImgPath('assets/images/emptybag.png', size: 100.w),
          Text(
            "分类暂无礼物喔~",
            style: TextStyle(fontSize: 16.sp, color: Colors.white),
          )
        ]);
      }
    } else {
      // 背包禮物
      WsAccountCallPackageRes callPackageRes = res;

      final List<FreBackPackListInfo>? nonZeroFreBackPackList = callPackageRes.freBackPackList?.where((item) => item.quantity != 0).toList();


      if (nonZeroFreBackPackList!.isNotEmpty) {

        for (var item in nonZeroFreBackPackList) {
          widgetList.add(bagGift(item));
        }

        return GridView.count(
            crossAxisCount: 4,
            mainAxisSpacing: 30,
            crossAxisSpacing: 8,
            padding: EdgeInsets.only(top: 20.h, left: 15.w, right: 15.w),
            childAspectRatio: 0.7,
            children: widgetList);

      } else {

        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ImgUtil.buildFromImgPath('assets/images/emptybag.png', size: 100.w),
          Text(
            "分类暂无礼物喔~",
            style: TextStyle(fontSize: 16.sp, color: Colors.white),
          )
        ]);

      }
    }
  }

  //背包內容
  Widget bagGift(FreBackPackListInfo freBackPackListInfo) {
    bool isChoose = false;
    if (chooseFreBackPackListInfo != null) {
      if (chooseFreBackPackListInfo!.giftId == freBackPackListInfo.giftId!) {
        isChoose = true;
      }
    }

    TextStyle contentStyle () {
      return TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          color: Colors.white
      );
    }

    final String giftImageUrl = freBackPackListInfo?.giftImageUrl ?? '';
    final String giftName = freBackPackListInfo?.giftName ?? '';
    final String quantity = freBackPackListInfo?.quantity?.toString() ?? '';

    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(width: 1, color:  (isChoose) ? AppColors.mainPink : AppColors.mainTransparent)
        ),
        child: Column(
          children: [
            CachedNetworkImageUtil.load(HttpSetting.baseImagePath + giftImageUrl, size: 60.w),
            Container(height: 3.h),
            Container(
              alignment: Alignment.center,
              width: 82.w,
              child: Text(giftName,
                  overflow: TextOverflow.ellipsis,
                  style: contentStyle()),
            ),
            Text("x ${quantity}",
                style: contentStyle()),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          chooseGiftListInfo = null;
          chooseFreBackPackListInfo = freBackPackListInfo;
          giveGiftNum = "1";
          bannerUrl = chooseFreBackPackListInfo!.giftBannerUrl ?? '';
          activityLink = chooseFreBackPackListInfo!.activityLink ?? '';
        });
      },
    );
  }

  //禮物和價格
  Widget giftAndPriceWidget(GiftListInfo giftListInfo) {
    bool isChoose = false;
    if (chooseGiftListInfo != null) {
      if (chooseGiftListInfo!.giftId == giftListInfo.giftId!) {
        isChoose = true;
      }
    }

    final String giftImageUrl = giftListInfo?.giftImageUrl ?? '';
    final String giftName = giftListInfo?.giftName ?? '';
    final String coins = giftListInfo?.coins?.toInt().toString() ?? '';
    final String giftSideImageUrl = giftListInfo?.giftSideImageUrl?.toString() ?? '';


    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(width: 1, color:  (isChoose) ? appColorTheme.giftAndBagMainColor : AppColors.mainTransparent)
        ),
        child: Stack(
          children: [
            Column(
              children: [
                CachedNetworkImageUtil.load(HttpSetting.baseImagePath + giftImageUrl, size: 60.w),
                Container(height: 3.h),
                Container(
                  alignment: Alignment.center,
                  width: 82.w,
                  child: Text(
                    giftName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImgUtil.buildFromImgPath(appImageTheme.iconCoin, size: 16.w),
                      SizedBox(width: 1.w),
                      Text(
                        coins,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            (giftSideImageUrl.isNotEmpty)?Positioned(
              right: 0,top: 0,
              child:  Container(
                width: giftListInfo!.giftSideImageWidth!.toDouble(),
                height: giftListInfo!.giftSideImageHeight!.toDouble(),
                child: CachedNetworkImageUtil.load(HttpSetting.baseImagePath + giftSideImageUrl),
              ),
            ):Container()
          ],
        ),
      ),
      onTap: () {
        setState(() {
          chooseFreBackPackListInfo = null;
          chooseGiftListInfo = giftListInfo;
          giveGiftNum = '1';
          bannerUrl = giftListInfo.giftBannerUrl ?? '';
          activityLink = giftListInfo.activity_link ?? '';
        });
        // Navigator.pop(context);
      },
    );
  }

  //充值
  Widget rechargeWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImgUtil.buildFromImgPath(appImageTheme.iconCoin, size: 24.w),
        Text(
          viewModel.myCoin,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: Colors.white,
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 12.w),
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return appLinearGradientTheme.giftAndBagChargeTextColor.createShader(bounds);
            },
            child: InkWell(
              child: Text(
                "充值 >",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                RechargeUtil.showRechargeBottomSheet(theme: _theme); // 開啟充值彈窗
              },
            ),
          ),
        ),
      ],
    );
  }

  //送禮
  Widget giftGivingWidget(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        border: Border.all(color: appColorTheme.giftAndBagMainColor),
      ),
      child: Row(
        children: [
          GestureDetector(
              onTap: showGiveGiftNumMenu,
              child: Container(
                width: 52,
                height: 22,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 2),
                    Text(giveGiftNum,
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white
                        )
                    ),
                    Image.asset("assets/images/icon_uparrow.png", width: 16.w, height: 16.w)
                  ],
                ),
              )
          ),
          CommonButton(
            btnType: CommonButtonType.text,
            cornerType: CommonButtonCornerType.circle,
            isEnabledTapLimitTimer: true,
            margin: EdgeInsets.zero,
            width: 63,
            height: 22,
            colorBegin: appColorTheme.giftAndBagMainColor,
            colorEnd: appColorTheme.giftAndBagMainColor,
            text: '送礼',
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
              decoration: TextDecoration.none,
            ),
            onTap: () {
              if (giveGiftNum == '0') {
                BaseViewModel.showToast(context, '尚未选取礼物');
                return;
              }

              if (chooseGiftListInfo == null && chooseFreBackPackListInfo == null) {
                BaseViewModel.showToast(context, '尚未选取礼物');
                return;
              }

              // 禮物的部分
              if (chooseGiftListInfo != null) {
                GiftListInfo info = viewModel.getUpdateGiftListInfo(giftListInfo: chooseGiftListInfo, giveGiftNum: giveGiftNum);
                Navigator.pop(context);
                widget.onTapSendGift.call(info);
              }

              // 背包禮物的部分
              if (chooseFreBackPackListInfo != null) {
                Map<String,dynamic> map = {
                  'giveGiftNum': giveGiftNum,
                  'gift': chooseFreBackPackListInfo,
                };
                GiftListInfo info = viewModel.getGiftListInfoFromFreBackPackListInfo(freBackPackListInfo: chooseFreBackPackListInfo, giveGiftNum: giveGiftNum);
                Navigator.pop(context);
                widget.onTapSendGift.call(info);

              }
            },
          ),
        ],
      ),
    );
  }

  //禮物數量彈窗
  Future<void> showGiveGiftNumMenu() async {
    final result = await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(228, 440, 47, 100),
      color: AppColors.textFormBlack,
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(value: '自订', child: popupMenuItem('自订')),
        const ExpandPopupMenuDivider(
          color: AppColors.mainGrey,
        ),
        PopupMenuItem<String>(value: '520', child: popupMenuItem('520')),
        const ExpandPopupMenuDivider(
          color: AppColors.mainGrey,
        ),
        PopupMenuItem<String>(value: '99', child: popupMenuItem('99')),
        const ExpandPopupMenuDivider(
          color: AppColors.mainGrey,
        ),
        PopupMenuItem<String>(value: '66', child: popupMenuItem('66')),
        const ExpandPopupMenuDivider(
          color: AppColors.mainGrey,
        ),
        PopupMenuItem<String>(value: '10', child: popupMenuItem('10')),
        const ExpandPopupMenuDivider(
          color: AppColors.mainGrey,
        ),
        PopupMenuItem<String>(value: '1', child: popupMenuItem('1')),
      ],
    );
    print('');
    setState(() {
      if (result == "自订") {
        setState(() {
          doNotShowTextField = false;
          autofocus = true;
          FocusScope.of(context).requestFocus(_focusNode);
        });
      } else if (result != null) {
        giveGiftNum = result.toString();
      }
    });
  }

  //PopupMenuItem組件
  Widget popupMenuItem(String text) {
    return Container(
      padding: EdgeInsets.zero,
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 12.sp, color: Colors.white),
        ),
      ),
    );
  }
}

//自訂義分隔線
const double _kMenuDividerHeight = 1;

class ExpandPopupMenuDivider<T> extends PopupMenuEntry<T> {
  const ExpandPopupMenuDivider({
    Key? key,
    this.height = _kMenuDividerHeight,
    required this.color,
  }) : super(key: key);

  final double height;
  final Color color;

  @override
  bool represents(void value) => false;

  @override
  _ExpandPopupMenuDividerState createState() =>
      _ExpandPopupMenuDividerState(height, color);
}

class _ExpandPopupMenuDividerState extends State<ExpandPopupMenuDivider> {
  double height;
  Color color;

  _ExpandPopupMenuDividerState(this.height, this.color);

  @override
  Widget build(BuildContext context) => Divider(
    height: height,
    color: color,
    indent: 10,
    endIndent: 10,
  );
}

