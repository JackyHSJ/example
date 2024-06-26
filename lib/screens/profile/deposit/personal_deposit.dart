import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_number_option_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_point_coin_res.dart';
import 'package:frechat/screens/home/home_view_model.dart';
import 'package:frechat/screens/profile/benefit/protocol_txt.dart';
import 'package:frechat/screens/profile/deposit/personal_deposit_dialog.dart';
import 'package:frechat/screens/profile/deposit/personal_deposit_view_model.dart';
import 'package:frechat/screens/profile/online_service/chat/personal_online_service_chat.dart';
import 'package:frechat/screens/profile/personal_bookkeeping/personal_bookkeeping.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/assets_path/assets_txt_path.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/textfromasset/textfromasset_widget.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_txt_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class PersonalDeposit extends ConsumerStatefulWidget {
  const PersonalDeposit({super.key});

  @override
  ConsumerState<PersonalDeposit> createState() => _PersonalDepositState();
}

class _PersonalDepositState extends ConsumerState<PersonalDeposit> {

  late PersonalDepositViewModel viewModel;
  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppTxtTheme _appTxtTheme;


  @override
  void initState() {
    super.initState();
    viewModel = PersonalDepositViewModel(setState: setState, ref: ref, context: context);
    viewModel.init();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appLinearGradientTheme= _theme.getAppLinearGradientTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    _appTxtTheme = _theme.getAppTxtTheme;

    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();

    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: false,
      padding: EdgeInsets.only(top: paddingHeight),
      appBar: MainAppBar(
        theme: _theme,
        title: '账户余额',
        backgroundColor: _appColorTheme.appBarBackgroundColor,
        leading: IconButton(
          icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
          onPressed: () => BaseViewModel.popPage(context),
        ),
        actions: [
          IconButton(
            onPressed: () => BaseViewModel.pushPage(
                context,
                PersonalBookkeeping(
                    index: ref.read(userInfoProvider).memberInfo!.gender == 0
                        ? 1
                        : 0,
                    isFromBannerView: false)),
            icon:ImgUtil.buildFromImgPath(_appImageTheme.profileBenefitBtnIcon, size: 24) ,
          )
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: WidgetValue.horizontalPadding,
        ),
        decoration: BoxDecoration(
          gradient: _appLinearGradientTheme.depositBgColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMemberCoinsInfo(),
              const SizedBox(height: 8),
              _buildFirstRechargeBanner(),
               Text('请选择充值金币', style:_appTextTheme.depositTitleTextStyle),
              const SizedBox(height: 8),
              _buildRechargeList(),
              const SizedBox(height: 8),
              // 请选择支付方式
              // Visibility(
              //     visible: Platform.isAndroid,
              //     child: _buildRechargePlatforms()
              // ),
              Visibility(visible: Platform.isIOS, child: _buildIosDepositBtn()),
              const SizedBox(height: 20),
              _buildExplanation(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // iOS Button
  Widget _buildIosDepositBtn() {
    return GestureDetector(
      onTap: () => ref.read(appPaymentManagerProvider).memberRecharge(context, rechargeType: 2, selectPhraseOption: viewModel.selectPhraseOption),
      child: Container(
        alignment: Alignment.center,
        height: WidgetValue.mainComponentHeight,
        decoration: BoxDecoration(
            gradient: _appLinearGradientTheme.buttonPrimaryColor,
            borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2)),
        child: Text('立即充值', style: _appTextTheme.buttonPrimaryTextStyle),
      ),
    );
  }

  // 充值列表
  Widget _buildRechargeList() {
    return Consumer(builder: (context, ref, _) {
      final List<DepositOptionListInfo> phraseOptionList = ref.watch(userInfoProvider).depositNumberOption?.list ?? [];
      return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: phraseOptionList.length,
        itemBuilder: (context, index) {
          return _buildRechargeItem(phraseOptionList[index], index);
        },
      );
    });
  }

  // 充值項目
  Widget _buildRechargeItem(DepositOptionListInfo depositOptionListInfo, int index) {
    final num amount = depositOptionListInfo.amount ?? 0;
    final num coins = depositOptionListInfo.coins ?? 0;

    BoxDecoration decoration;
    Widget checkBox;

    if (viewModel.selectPhraseOption == depositOptionListInfo) {
      decoration = _appBoxDecorationTheme.cellSelectBoxDecoration;
      checkBox = ImgUtil.buildFromImgPath(_appImageTheme.checkBoxTrueIcon, size: 24);
    } else {
      decoration = _appBoxDecorationTheme.cellBoxDecoration;
      checkBox = ImgUtil.buildFromImgPath(_appImageTheme.checkBoxFalseIcon, size: 24);
    }

    return InkWell(
      onTap: () {
          viewModel.rechargeCoinsHandler(depositOptionListInfo);
          if (!Platform.isIOS) showAndroidRechargeBottomSheet();
        },
        child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: decoration,
        child: Row(
          children: [
            ImgUtil.buildFromImgPath(_appImageTheme.iconCoin, size: 24),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$coins', style:_appTextTheme.depositCoinTitleTextStyle),
                  Text('￥$amount', style:_appTextTheme.depositCoinSubTitleTextStyle,)
                ],
              ),
            ),
            checkBox,
          ],
        ),
      ),
    );
  }

  // 我的金幣
  Widget _buildMemberCoinsInfo() {
    final WsMemberPointCoinRes? myCoins = ref.read(userInfoProvider).memberPointCoin;
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppImageTheme appImageTheme = theme.getAppImageTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImgUtil.buildFromImgPath(appImageTheme.missionCoinIcon, size: 24),
        Text('我的金币', style: _appTextTheme.depositCoinTitleTextStyle),
        Text((myCoins?.coins ?? 0).toInt().toString(), style:_appTextTheme.depositCoinTotalTextStyle),
      ],
    );
  }

  // 首充 Banner
  Widget _buildFirstRechargeBanner() {

    // 充值次數
    final num rechargeCounts = ref.read(userInfoProvider).memberPointCoin?.depositCount ?? 0;

    if (rechargeCounts > 0) {
      return const SizedBox();
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: GestureDetector(
        onTap: () => RechargeUtil.showFirstTimeRechargeDialog(''),
        child: AspectRatio(
          aspectRatio: 5.5833,
          child: ImgUtil.buildFromImgPath(_appImageTheme.firstRechargeBanner, fit: BoxFit.contain),
        ),
      ),
    );
  }

  // 說明
  Widget _buildExplanation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExplanationTitle(),
        const SizedBox(height: 8),
        _buildExplanationItem(),
        const SizedBox(height: 4),
        _buildExplanationItem1(),
        const SizedBox(height: 4),
        _buildExplanationItem2(),
        const SizedBox(height: 4),
        _buildExplanationItem3(),
        const SizedBox(height: 4),
        _buildExplanationItem4(),
      ],
    );
  }

  Widget _buildExplanationTitle() {
    return  Text('说明', style: _appTextTheme.depositDirectionsTitleTextStyle);
  }

  Widget _buildExplanationItem() {

    return Row(
      children: [
        Text(' • 充值即代表已阅读并同意 ', style:_appTextTheme.depositDirectionsContentTextStyle),
        InkWell(
          onTap: () async {
            BaseViewModel.pushPage(context, TextFromAssetWidget(
              title: '${AppConfig.appName}充值协议',
              filePath: _appTxtTheme.rechargeProtocol),
            );
          },
          child: Text('《${AppConfig.appName}充值协议》',style:_appTextTheme.depositDirectionsHighLightTextStyle)),
      ],
    );
  }

  Widget _buildExplanationItem1() {
    return Row(
      children: [
        Text(' • 关注${AppConfig.appName} APP ',
            style: _appTextTheme.depositDirectionsContentTextStyle),
        InkWell(
            onTap: () {
              BaseViewModel.copyText(context, copyText: '缘遇缘茵文化');
            },
            child: Text('公众号', style:_appTextTheme.depositDirectionsHighLightTextStyle)),
      ],
    );
  }

  Widget _buildExplanationItem2() {
    return Text(' • 前往收支纪录，可查询充值订单详情和消费详情', style: _appTextTheme.depositDirectionsContentTextStyle);
  }

  Widget _buildExplanationItem3() {
    return Row(
      children: [
        Text(' • 禁止未成年进行充值，点击详见，', style: _appTextTheme.depositDirectionsContentTextStyle),
        InkWell(
          onTap: () async {
            BaseViewModel.pushPage(context, TextFromAssetWidget(
              title: '未成年人保护计划',
              filePath: _appTxtTheme.teenProtectPlan,
            ));
          },
          child: Text('《未成年保护计划》', style: _appTextTheme.depositDirectionsHighLightTextStyle),
        ),
      ],
    );
  }

  Widget _buildExplanationItem4() {
    return Row(
      children: [
        Text(' • 在充值过程中如遇任何问题，可联系 ', style: _appTextTheme.depositDirectionsContentTextStyle),
        InkWell(
          onTap: () {
            BaseViewModel.pushPage(context, PersonalOnlineServiceChat());
          },
          child: Text('官方客服', style: _appTextTheme.depositDirectionsHighLightTextStyle),
        ),
      ],
    );
  }

  // 选择金额后底部彈窗
  void showAndroidRechargeBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return PersonalDepositDialog(
          selectPhraseOption: viewModel.selectPhraseOption,
        );
      },
    );
  }
}
