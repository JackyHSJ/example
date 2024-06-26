import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:frechat/models/ws_res/withdraw/ws_withdraw_member_income_res.dart';

import 'package:frechat/screens/profile/benefit/personal_benefit_view_model.dart';
import 'package:frechat/screens/profile/personal_bookkeeping/personal_bookkeeping.dart';
import 'package:frechat/screens/profile/benefit/bank/personal_benefit_withdraw_account.dart';

import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/providers.dart';

import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/rounded_textfield.dart';

class PersonalBenefit extends ConsumerStatefulWidget {

  bool isFromBannerView;

  PersonalBenefit({
    super.key,
    required this.isFromBannerView
  });

  @override
  ConsumerState<PersonalBenefit> createState() => _PersonalBenefitState();
}

class _PersonalBenefitState extends ConsumerState<PersonalBenefit> {

  late PersonalBenefitViewModel viewModel;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppTextTheme _appTextTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  @override
  void initState() {
    super.initState();
    viewModel = PersonalBenefitViewModel(ref: ref, setState: setState, context: context);
    viewModel.init();
  }

  @override
  Widget build(BuildContext context) {

    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;

    return MainScaffold(
        isFullScreen: true,
        needSingleScroll: true,
        padding: EdgeInsets.only(
          top: paddingHeight,
          bottom: WidgetValue.bottomPadding,
          left: WidgetValue.horizontalPadding,
          right: WidgetValue.horizontalPadding,
        ),
        appBar: _buildAppbar(),
        backgroundColor: _appColorTheme.appBarBackgroundColor,
        child: viewModel.isLoading ? _buildLoading() : _buildMainContent()
    );
  }

  Widget _buildAppbar() {

    return MainAppBar(
      theme: _theme,
      backgroundColor: _appColorTheme.appBarBackgroundColor,
      title: '我的收益',
      leading: IconButton(
        icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
        onPressed: () => BaseViewModel.popPage(context),
      ),
      actions: [_buildPersonalBookKeepingActionButton()],
    );
  }

  Widget _buildLoading() {
    return LoadingAnimation.discreteCircle(color: _appColorTheme.primaryColor);
  }

  Widget _buildMainContent() {

    return Container(
      color: _appColorTheme.appBarBackgroundColor,
      child: Column(
        children: [
          //主要排列內容於此
          //上方總覽
          _buildTopSummaryView(),
          //提現，兌換操作 (白框含內)
          _buildWithdrawExchangeSelectionView(),
          //提現，兌換操作 (白框外，下半部)
          _buildWithdrawExchangeConfirmView(),
        ],
      ),
    );
  }

  //右上角收支明細按鈕
  Widget _buildPersonalBookKeepingActionButton() {
    num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    return IconButton(
      onPressed: () {
        BaseViewModel.pushPage(context, PersonalBookkeeping(index: gender == 0 ? 1 : 0,isFromBannerView: false));
      },
      icon: ImgUtil.buildFromImgPath('assets/profile/profile_benefit_btn_icon.png', size: 24.w),
    );
  }

  ///最上方總覽區域
  Widget _buildTopSummaryView() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          _buildTopSummaryTitleText(),
          _buildTopSummaryPointsText(),
          _buildTopSummaryIncomeText(),
        ],
      ),
    );
  }

  Widget _buildTopSummaryTitleText() {
    return Column(
      children: [
        Text(
          '积分余额',
          style: TextStyle(
            fontSize: 14,
            color: _appColorTheme.benefitInfoTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTopSummaryPointsText() {
    final bool isIOS = Platform.isIOS;

    return Column(
      children: [
        Text(
          '${viewModel.points}',
          // points.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 28,
            color: _appColorTheme.benefitInfoTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Visibility(
          visible: !isIOS,
          child: Text(
            '约 ${viewModel.pointsToRMB} 元',
            // '约 ${(points / 10).toStringAsFixed(2)} 元',
            style: TextStyle(
              fontSize: 14,
              color: _appColorTheme.benefitInfoTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopSummaryIncomeText() {

    // 修改需求只显示今日和审核中
    // '收益：今日 $todayIncome | 审核中 withdrawalAmount
    // '收益：今日 $todayIncome',

    String text = '收益：今日 ${viewModel.todayIncome} | 审核中 ${viewModel.withdrawalAmount}';
    final bool isIOS = Platform.isIOS;
    if (isIOS) {
      text = '收益：今日 ${viewModel.todayIncome}';
    }
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      child: Text(
        text,
        style: TextStyle(
          color: _appColorTheme.benefitSecondaryTextColor,
          fontWeight: FontWeight.w400,
          fontSize: 12
        ),
      ),
    );
  }

  ///提現，兌換操作上區
  Widget _buildWithdrawExchangeSelectionView() {
    final bool isIOS = Platform.isIOS;
    final bool isAndroid = Platform.isAndroid;

    BoxDecoration decoration = _appBoxDecorationTheme.benefitTabUnActiveBoxDecoration;

    List<Widget> tabItems = [];

    if (viewModel.showWithdrawType) {
      tabItems.add(_buildTabItem('收益提现', 0));
    }
    tabItems.add(_buildTabItem('兑换金币', 1));

    Widget tabSelection;

    if (viewModel.tabIndex == 0) {
      tabSelection = _buildWithdrawIncomeSelectionView();
    } else {
      tabSelection = _buildExchangeInputView();
    }

    return Container(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 16),
      decoration: _appBoxDecorationTheme.benefitSelectViewBoxDecoration,
      child: Column(
        children: [
          Container(
            decoration: decoration,
            child: Row(
              children: tabItems
            ),
          ),
          tabSelection,
        ],
      ),
    );
  }

  //提現 tabs 選擇介面
  Widget _buildWithdrawIncomeSelectionView() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildHint(),
        const SizedBox(height: 8),
        //選項 grids tabs
        _buildOption(),
      ],
    );
  }

  Widget _buildHint() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ImgUtil.buildFromImgPath(_appImageTheme.iconCoin, size: 24),
        const Text('请选择您想提领的金额', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Color(0xffF4A23E)),),
      ],
    );
  }

  Widget _buildOption() {

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 101 / 48
      ),
      itemCount: viewModel.withdrawIncomeList.length,
      itemBuilder: (context, index) {
        return _buildOptionItem(viewModel.withdrawIncomeList[index], index);
      },
    );
  }

  Widget _buildOptionItem(WithdrawIncomeListInfo info, int index) {

    BoxDecoration displayBoxDecoration;
    TextStyle displayTextStyle;
    String realTimeDeposit = _appImageTheme.iconRealtimeDepositActivate;
    double positionHorizontal = 0;

    if (viewModel.withdrawIncomeIndex == index) {
      displayBoxDecoration = _appBoxDecorationTheme.benefitItemSelectedBoxDecoration;
      displayTextStyle = _appTextTheme.benefitItemSelectedTextStyle;
    } else {
      displayBoxDecoration = _appBoxDecorationTheme.benefitItemUnSelectBoxDecoration;
      displayTextStyle = _appTextTheme.benefitItemUnSelectTextStyle;
    }

    num moneyRange = double.parse(info.moneyRange ?? '0');

    if (viewModel.pointsToRMB  <  moneyRange) {
      displayBoxDecoration = _appBoxDecorationTheme.benefitItemDisableBoxDecoration;
      displayTextStyle = _appTextTheme.benefitItemDisableTextStyle;
      realTimeDeposit = _appImageTheme.iconRealtimeDepositDeactivate;
    }

    if (info.secondTransfer == '0') {
      realTimeDeposit = '';
    }

    if (_theme.themeType == AppThemeType.yueyuan) {
      positionHorizontal = -8;
    }

    // iconRealtimeDeposit
    return InkWell(
      onTap: () {
        if (viewModel.pointsToRMB  >=  moneyRange) {
          viewModel.withdrawIncomeHandler(index);
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: displayBoxDecoration,
            child: Center(
              child: FittedBox(
                child: Text(
                  '${info.moneyRange}元',
                  style: displayTextStyle
                ),
              ),
            )
          ),
          Positioned(
            top: -10,
            right: positionHorizontal,
            child: ImgUtil.buildFromImgPath(realTimeDeposit, width: 60, height: 24),
          ),
        ],
      ),

    );
  }

  ///收益提現/兌換金币 選單切換按鈕
  Widget _buildTabItem(String title, int index) {

    BoxDecoration decoration;

    Color color;

    if (viewModel.tabIndex == index) {
      decoration = _appBoxDecorationTheme.benefitTabActiveBoxDecoration;
      color = _appColorTheme.benefitActiveTextColor;
    } else {
      decoration = _appBoxDecorationTheme.benefitTabUnActiveBoxDecoration;
      color = _appColorTheme.benefitUnActiveTextColor;
    }

    return Expanded (
      child: InkWell(
        onTap: () {
          viewModel.tabHandler(index);
        },
        child: Container(
          decoration: decoration,
          height: 42,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: color
              ),
            ),
          ),
        ),
      ),
    );
  }


  ///兌換輸入框
  Widget _buildExchangeInputView() {
    String points = '0';
    String coins = '0';

    //從 _exchangeTextEditController.text 取積分算成金幣
    if (viewModel.exchangeTextEditController.text.isNotEmpty) {
      double? inputPoint = double.tryParse(viewModel.exchangeTextEditController.text);
      if (inputPoint != null) {
        points = inputPoint.toStringAsFixed(2);
        //固定為 1:1
        coins = points;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        children: [
          FittedBox(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImgUtil.buildFromImgPath(_appImageTheme.iconPoints, size: 24.w),
                const SizedBox(width: 2),
                Text('積分 $points', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xffFF9A7A))),
                const SizedBox(width: 12),
                ImgUtil.buildFromImgPath(_appImageTheme.iconExchange, size: 24.w),
                const SizedBox(width: 12),
                ImgUtil.buildFromImgPath(_appImageTheme.iconCoin, size: 24.w),
                const SizedBox(width: 2),
                Text('金币 $coins', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xffFFC250))),
              ],
            ),
          ),
          const SizedBox(height: 9),
          RoundedTextField(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            radius: 8,
            textEditingController: viewModel.exchangeTextEditController,
            textInputType: TextInputType.number,
            hint: '请输入要使用的积分',
            textAlign: TextAlign.center,
            hintTextStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.mainGrey,
            ),
            onChange: (text) {
              if(!isNumeric(text)){
                viewModel.exchangeTextEditController.clear();
                points = "0";
                coins = "0";
                viewModel.showToast('积分须为整数');
              }
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  bool isNumeric(String value) {
    if (value == null) {
      return false;
    }
    return (int.tryParse(value) != null);
  }

  // 下半部
  Widget _buildWithdrawExchangeConfirmView() {
    //也是受上方 tab 選擇影響。
    return viewModel.tabIndex == 0
        ? _buildWithdrawConfirmView()
        : _buildExchangeConfirmView();
  }

  Future<void> _buildWithdrawDialog(String des, double withdrawAmount) async {
    await CheckDialog.show(context,
      appTheme: _theme,
      titleText: '提现',
      messageText: des,
      confirmButtonText: '提现',
      showCancelButton: true,
      onConfirmPress: () async {
        // 提現 API
        await viewModel.memberWithdrawal(viewModel.defaultWithdrawAccount!.type!, withdrawAmount);
        //  更新點數金額、提現金額選項 tab
        await viewModel.getMemberInfo();
        await viewModel.getWithdrawMemberIncome();
      },
    );
  }

  Future<void> _buildWithdrawWarningDialog() async {
    await CheckDialog.show(context, titleText: '注意', messageText: '首次提现请先阅读并且勾选同意协议书', appTheme: _theme);
  }

  /// 下方提現確認介面
  Widget _buildWithdrawConfirmView() {
    // 決定立即提現按鈕是否可用
    Widget withdrawButton = const SizedBox();
    if (viewModel.isRealNameAuth && viewModel.defaultWithdrawAccount != null) {
      withdrawButton = _confirmButton(
        text: '立即提现',
        onTap: () async => viewModel.withdrawalFunction(
          onWithdrawDialog: (des, withdrawAmount) => _buildWithdrawDialog(des, withdrawAmount),
          onWithdrawWarningDialog: () => _buildWithdrawWarningDialog()
        )
      );
    } else {
      withdrawButton = _disableButton(
        text: '立即提现',
        onTap: () async {
          //Show the reason why the button is disabled.
          if (!viewModel.isRealNameAuth) {
            await CheckDialog.show(context,
                appTheme: _theme,
                titleText: '错误', messageText: '您尚未通过实名验证，无法提现');
          } else if (viewModel.defaultWithdrawAccount == null) {
            await CheckDialog.show(context,
                appTheme: _theme,
                titleText: '错误', messageText: '请先选择提现账号');
          }
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildWithdrawAccountSelectionOrBinding(),
          const SizedBox(height: 12),
          withdrawButton,
          viewModel.firstWithdrawal == '1'
              ? _buildWithdrawAgreementCheckLink()
              : const SizedBox(),
          const SizedBox(height: 12),
          _buildExplanation()
        ],
      ),
    );
  }

  /// 提現帳號選擇或者綁定按鈕 UI
  Widget _buildWithdrawAccountSelectionOrBinding() {
    if (viewModel.defaultWithdrawAccount != null) {
      return _buildWithdrawAccountSelection();
    } else {
      return _buildWithdrawAccountBinding();
    }
  }

  /// 提現帳號綁定按鈕介面
  Widget _buildWithdrawAccountBinding() {
    Widget setBindingButton = _confirmButton(
      text: '前往绑定',
      onTap: () async {
        await BaseViewModel.pushPage(context, const PersonalBenefitWithdrawAccount());
        //重取
        await viewModel.getWithdrawSearchPayment();
        setState(() {});
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '收款账号',
          style: TextStyle(
            color: _appColorTheme.benefitPrimaryTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 16
          ),
        ),
        Text(
          '尚未绑定账号',
          style: TextStyle(
            color: _appColorTheme.benefitSecondaryTextColor,
            fontWeight: FontWeight.w400,
            fontSize: 14
          ),
        ),
        const SizedBox(height: 8),
        setBindingButton,
      ],
    );
  }

  /// 提現帳號選擇介面
  Widget _buildWithdrawAccountSelection() {
    //取得當前預設帳號作為顯示選取依據
    String selectedAccountBrandName = '--';
    String selectedAccountNumber = '--';
    if (viewModel.defaultWithdrawAccount != null) {
      selectedAccountBrandName =
          "${_getWithdrawAccountBrandName(viewModel.defaultWithdrawAccount!.type)}${viewModel.defaultWithdrawAccount!.status == 1 ? ' (预设)' : ''}";
      if (viewModel.defaultWithdrawAccount!.account != null) {
        String numberStr = viewModel.defaultWithdrawAccount!.account!.toString();
        try {
          int replaceLength = numberStr.length - 2 - 3;
          selectedAccountNumber = numberStr.replaceRange(3, numberStr.length - 2, '*' * replaceLength);
        } catch(e) {
          selectedAccountNumber = numberStr;
        }

      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '收款账号',
          style: TextStyle(
              color: _appColorTheme.benefitPrimaryTextColor,
              fontWeight: FontWeight.w700,
              fontSize: 16
          ),
        ),
        Text(
          selectedAccountBrandName,
          style: TextStyle(
            color: _appColorTheme.benefitSecondaryTextColor,
            fontWeight: FontWeight.w400,
            fontSize: 14
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        InkWell(
          onTap: () async {
            await BaseViewModel.pushPage(context, const PersonalBenefitWithdrawAccount());
            //重取
            await viewModel.getWithdrawSearchPayment();
            setState(() {});
          },
          child: Container(
            height: kMinInteractiveDimension,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedAccountNumber,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///同意提現條款 Checkbox + Link
  Widget _buildWithdrawAgreementCheckLink() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FittedBox(
        child: Row(
          children: [
            _buildCloudWithdrawAgreementCheckBox(),
            const SizedBox(width: 4),
            Text(
              '我自愿遵守并同意',
              style: TextStyle(
                color: _appColorTheme.benefitPrimaryTextColor,
                fontWeight: FontWeight.w400,
                fontSize: 14
              ),
            ),
            InkWell(
              onTap: () {
                if (viewModel.cloudWithdrawalAgreementUrl.isNotEmpty) {
                  launchUrl(Uri.parse(viewModel.cloudWithdrawalAgreementUrl));
                }
              },
              child: Text(
                '《灵活就业合作伙伴合作协议》',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationColor: _appColorTheme.benefitLinkTextColor,
                  color: _appColorTheme.benefitLinkTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  Widget _buildCloudWithdrawAgreementCheckBox() {

    String checkBox;

    if (viewModel.checkCloudAgreement) {
      checkBox = _appImageTheme.iconBenefitCloudCheckActivate;
    } else {
      checkBox = _appImageTheme.iconBenefitCloudCheckDeactivate;
    }

    return InkWell(
      onTap: () {
        setState(() => viewModel.cloudAgreementHandler());
      },
      child: ImgUtil.buildFromImgPath(checkBox, size: 24),
    );
  }

  /// 下方兌換確認 UI 部分
  Widget _buildExchangeConfirmView() {
    bool enableExchange = false;
    double? inputPoint;
    //檢查 _exchangeTextEditController 文字內容來判斷是否按鈕是否可用
    //同時檢查是否點數足夠 (從 _wsMemberPointCoinRes)
    if (viewModel.exchangeTextEditController.text.isNotEmpty) {
      inputPoint = double.tryParse(viewModel.exchangeTextEditController.text);
      if (inputPoint != null &&
          inputPoint <= viewModel.points &&
          inputPoint > 0) {
        enableExchange = true;
      }else if(inputPoint! > viewModel.points){
        viewModel.showToast('可兑换积分已达上限');
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          enableExchange
              ? _confirmButton(
                  text: '立即兑换',
                  onTap: () async {
                    //Ask user
                    await CheckDialog.show(context,
                        appTheme: _theme,
                        titleText: '兑换',
                        messageText: '您将以 $inputPoint 积分兑换 $inputPoint 金币',
                        showCancelButton: true, onConfirmPress: () async {
                      //執行兌換
                      int? inputPoint = int.tryParse(viewModel.exchangeTextEditController.text);

                      if (inputPoint != null && inputPoint >= 1) {
                        if (inputPoint <= viewModel.points) {
                          await viewModel.withdrawMemberPointToCoin(inputPoint);
                          await viewModel.getMemberInfo();
                        }
                      } else {
                        await CheckDialog.show(context,titleText: '错误', messageText: '输入数字必须为整数并不小于1', appTheme: _theme);
                      }
                    });
                  },
                )
              : _disableButton(text: '立即兑换',onTap: (){}),
          const SizedBox(
            height: 12,
          ),
          // 說明
          Text('说明', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _appColorTheme.benefitPrimaryTextColor)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(' • ', style: TextStyle(color: _appColorTheme.benefitPrimaryTextColor),),
            Expanded(child: Text('兑换来源为您的积分馀额(元)', style: TextStyle(color: _appColorTheme.benefitPrimaryTextColor),))
            ],
          )
        ],
      ),
    );
  }

  ///取得金融機構名稱
  String _getWithdrawAccountBrandName(num? type) {
    switch (type) {
      case 1:
        return '支付宝';
      case 2:
        return '微信支付';
      default:
        return '未定義第三方';
    }
  }


  Widget _confirmButton({required String text,required Function() onTap}){
    final AppLinearGradientTheme appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    final AppTextTheme appTextTheme = _theme.getAppTextTheme;

    return CommonButton(
        btnType: CommonButtonType.text,
        cornerType: CommonButtonCornerType.circle,
        isEnabledTapLimitTimer: false,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        text: text,
        textStyle: appTextTheme.buttonPrimaryTextStyle,
        colorBegin: appLinearGradientTheme.buttonPrimaryColor.colors[0],
        colorEnd: appLinearGradientTheme.buttonPrimaryColor.colors[1],
        onTap: () {
          onTap();
        });
  }
  Widget _disableButton({required String text,required Function() onTap}){
    final AppLinearGradientTheme appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    final AppTextTheme appTextTheme = _theme.getAppTextTheme;

    return CommonButton(
      btnType: CommonButtonType.text,
      cornerType: CommonButtonCornerType.circle,
      isEnabledTapLimitTimer: false,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      text: text,
      textStyle: appTextTheme.buttonSecondaryTextStyle,
      colorBegin: appLinearGradientTheme.buttonSecondaryColor.colors[0],
      colorEnd: appLinearGradientTheme.buttonSecondaryColor.colors[1],
      onTap: () {
        onTap();
      },
    );
  }

  //
  // 說明
  //

  Widget _buildExplanation() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('说明', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _appColorTheme.benefitPrimaryTextColor)),
          const SizedBox(height: 8),
          _buildExplanationList(),
          const SizedBox(height: 30)
        ],
      ),
    );
  }

  Widget _buildExplanationList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: viewModel.explanationList.length,
      itemBuilder: (context, index) {
        return _buildExplanationItem(viewModel.explanationList[index]);
      },
    );
  }

  Widget _buildExplanationItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(' • ', style: TextStyle(color: _appColorTheme.benefitPrimaryTextColor),),
        Expanded(child: Text(text, style: TextStyle(color: _appColorTheme.benefitPrimaryTextColor),))
      ],
    );
  }
}
