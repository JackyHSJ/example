import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_save_aipay_req.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_search_payment_req.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_search_payment_res.dart';
import 'package:frechat/screens/profile/benefit/bank/personal_benefit_withdraw_account_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/loading_dialog/loading_widget.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import '../../../../../system/base_view_model.dart';
import '../../../../../system/providers.dart';
import '../../../../widgets/theme/original/app_colors.dart';
import '../../certification/real_name/personal_certification_real_name.dart';
import 'personal_benefit_withdraw_account_bind.dart';

class PersonalBenefitWithdrawAccount extends ConsumerStatefulWidget {
  const PersonalBenefitWithdrawAccount({
    super.key,
  });

  @override
  ConsumerState<PersonalBenefitWithdrawAccount> createState() => _PersonalBenefitBankAccountState();
}

class _PersonalBenefitBankAccountState extends ConsumerState<PersonalBenefitWithdrawAccount> {

  late PersonalBenefitWithdrawAccountViewModel viewModel;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;

  @override
  void initState() {
    super.initState();
    viewModel = PersonalBenefitWithdrawAccountViewModel(ref: ref, context: context, setState: setState);
    viewModel.init();
  }

  ///這會嘗試搜尋 _wsWithdrawSearchPaymentRes 來取得回傳第一個符合 type 的 ListInfo
  ///Returns null if none found.
  WithdrawPaymentListInfo? _tryGetFirstListInfoOfType(num type) {
    if (viewModel.wsWithdrawSearchPaymentRes != null &&
        viewModel.wsWithdrawSearchPaymentRes!.list != null) {
      for (WithdrawPaymentListInfo listInfo
          in viewModel.wsWithdrawSearchPaymentRes!.list!) {
        if (listInfo.type == type) {
          return listInfo;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    //我們就只在這邊取一次 memberInfo
    WsMemberInfoRes? memberInfo = ref.read(userInfoProvider).memberInfo;
    bool hasRealNameAuth = false;
    if (memberInfo != null) {
      hasRealNameAuth = (memberInfo.realNameAuth == 1);
    }

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(
        theme: _theme,
        backgroundColor: _appColorTheme.appBarBackgroundColor,
        title: '收款账号',
        leading: IconButton(
          icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
          onPressed: () => BaseViewModel.popPage(context),
        ),
      ),
      body: Container(
        color: _appColorTheme.appBarBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: viewModel.isInitializing
              ? _buildLoading()
              : Column(
            children: [
              //注意 Server 事實上只支援各家支付帳號各一組，因此這邊我們就列出各家並檢查是否存在綁定帳號

              //目前我們固定只顯示一組支付寶 item (以後再加上其他家支付顯示)
              //支付寶 (type = 1)
              _buildWithdrawAccountItem(
                  paymentListInfo: _tryGetFirstListInfoOfType(1),
                  accountType: 1,
                  hasRealNameAuth: hasRealNameAuth,
                  onTap: () {
                    //這個其實是不用的嗎??? 我們根本不需要選擇帳號功能?
                    // WithdrawPaymentListInfo? withdrawPaymentListInfo = _tryGetFirstListInfoOfType(1);
                    // if (withdrawPaymentListInfo != null) {
                    //   Navigator.of(context).pop(withdrawPaymentListInfo);
                    // }
                  }),

              //微信支付 (type = 2)
              // _buildWithdrawAccountItem(
              //     paymentListInfo: _tryGetFirstListInfoOfType(2),
              //     accountType: 2,
              //     hasRealNameAuth: hasRealPersonAuth,
              //     onTap: () {}),
            ],
          ),
        ),
      )
    );
  }

  Widget _buildLoading() {
    return LoadingAnimation.discreteCircle(color: _appColorTheme.primaryColor);
  }

  ///每行支付項目組成
  Widget _buildWithdrawAccountItem({
    WithdrawPaymentListInfo? paymentListInfo,
    required num accountType,
    required bool hasRealNameAuth,
    required Function() onTap
  }) {
    //Logo
    Widget accountImage = ImgUtil.buildFromImgPath(_getWithdrawAccountLogoImageAssetPath(accountType), size: 24);

    //Subtitle
    String subTitle = '--';
    Widget trailEditButton = const SizedBox();
    if (hasRealNameAuth) {
      if (paymentListInfo != null) {
        subTitle = '已完成绑定';
        //顯示編輯按鈕
        trailEditButton = _accountItemEditButton(
          text: '前往编辑',
          onTap: () async {
            if (viewModel.wsWithdrawSearchPaymentRes != null) {
              await BaseViewModel.pushPage(
                  context,
                  PersonalBenefitWithdrawAccountBind(
                    accountType: accountType,
                    existWithdrawSearchPaymentRes: viewModel.wsWithdrawSearchPaymentRes!,
                    existWithdrawPaymentListInfo: paymentListInfo,
                  ));
              await viewModel.getWithdrawSearchPayment();
              if (mounted) {
                setState(() {});
              }
            }
          },
        );
      } else {
        subTitle = '尚未綁定';
        trailEditButton = _accountItemBindingButton(
          text: '前往绑定',
          onTap: () async {
            await _tryPushToWithdrawAccountBindNew(accountType);
          },
        );
      }
    } else {
      subTitle = '尚未通过实名验证';
      trailEditButton = _accountItemBindingButton(
        text: '前往验证',
        onTap: () async {
          //注意這邊需要取得回复是否驗證成功
          bool? result = await BaseViewModel.pushPage(
              context, const PersonalCertificationRealName());
          if (mounted) {
            Loading.show(context, '更新中...');
          }
          await viewModel.getWithdrawSearchPayment();
          if (mounted) {
            Loading.hide(context);
            setState(() {});
          }
          if (result == true) {
            if (mounted) {
              //實名驗證成功，更新過後直接自動進入綁定頁面吧
              await _tryPushToWithdrawAccountBindNew(accountType);
            }
          }
        },
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      width: double.infinity,
      height: 62,
      decoration: _appBoxDecorationTheme.cellBoxDecoration,
      child: Row(
        children: [
          accountImage,
          SizedBox(width: 8),
          Expanded(child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_getWithdrawAccountBrandName(accountType)}', style: _appTextTheme.withdrawAccountTitle),
              Text('$subTitle', style: _appTextTheme.withdrawAccountSubTitle),
            ],
          ),),
          trailEditButton
        ],
      ),
    );
  }

  //進入帳號綁定頁面
  Future _tryPushToWithdrawAccountBindNew(num accountType) async {
    if (viewModel.wsWithdrawSearchPaymentRes != null ) {
      await BaseViewModel.pushPage(
          context,
          PersonalBenefitWithdrawAccountBind(
              accountType: accountType,
              existWithdrawSearchPaymentRes:
              viewModel.wsWithdrawSearchPaymentRes!));
      if (mounted) {
        Loading.show(context, '更新中...');
      }
      await viewModel.getWithdrawSearchPayment();
      if (mounted) {
        Loading.hide(context);
        setState(() {});
      }
    }
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

  ///取得支付機構商標
  String _getWithdrawAccountLogoImageAssetPath(num? type) {
    switch (type) {
      case 1:
        return 'assets/strike_up_list/pay_1.png';
      case 2:
        return 'assets/strike_up_list/pay_2.png';
      default:
        return 'assets/strike_up_list/pay_3.png';
    }
  }


  // 編輯按鈕
  Widget _accountItemEditButton({required String text,required Function() onTap}){

    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: 32,
        decoration: _appBoxDecorationTheme.tvSelectedTextBoxDecoration,
        child: Center(
          child: Text(
            '$text',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _appColorTheme.tvSelectedTextColor),
          ),
        ),
      ),
    );
  }

  Widget _accountItemBindingButton({required String text,required Function() onTap}){

    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: 32,
        decoration: _appBoxDecorationTheme.tvSelectedTextBoxDecoration,
        child: Center(
          child: Text(
            '$text',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _appColorTheme.tvSelectedTextColor),
          ),
        ),
      ),
    );
  }
}
