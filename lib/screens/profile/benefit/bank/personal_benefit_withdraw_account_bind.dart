import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_save_aipay_req.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_search_payment_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/loading_dialog/loading_widget.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/rounded_textfield.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

import '../../../../widgets/shared/buttons/gradient_button.dart';

class PersonalBenefitWithdrawAccountBind extends ConsumerStatefulWidget {
  //1 = 支付寶
  //2 = 微信支付
  final num accountType;
  //已知的個人綁定帳號主體資料 (必須傳) (這是要取實名姓名跟ID)
  final WsWithdrawSearchPaymentRes existWithdrawSearchPaymentRes;
  //有傳這個進來代表是編輯現有帳戶, 沒傳代表要建新帳戶
  final WithdrawPaymentListInfo? existWithdrawPaymentListInfo;
  const PersonalBenefitWithdrawAccountBind({
    super.key,
    required this.accountType,
    required this.existWithdrawSearchPaymentRes,
    this.existWithdrawPaymentListInfo
  });

  @override
  ConsumerState<PersonalBenefitWithdrawAccountBind> createState() => _PersonalBenefitBankBindState();

}

class _PersonalBenefitBankBindState extends ConsumerState<PersonalBenefitWithdrawAccountBind> {
  final TextEditingController _accountTextEditController = TextEditingController();

  late AppTheme _theme;
  late AppImageTheme _appImageTheme;
  late AppColorTheme _appColorTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  @override
  void initState() {
    if (widget.existWithdrawPaymentListInfo != null) {
      _accountTextEditController.text = widget.existWithdrawPaymentListInfo!.account!;
    }
    // print('[existWithdrawSearchPaymentRes]: ${jsonEncode(widget.existWithdrawSearchPaymentRes)}');
    super.initState();
  }

  ///9-7(儲存或是修改支付寶帳號)
  Future _wsWithdrawSaveAlipay_9_7(
      {required String function,
        required String account,
        required num type,
        required num status}) async {
    String resultCodeCheck = '';
    final reqBody = WsWithdrawSaveAiPayReq.create(
        function: function,
        account: account,
        type: type.toString(),
        status: status.toString());

    await ref.read(withdrawWsProvider).wsWithdrawSaveAlipay(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg);
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      //Success
    } else {
      if (mounted) {
        await CheckDialog.show(context,
            appTheme: _theme,
            titleText: '错误',
            messageText: ResponseCode.getLocalizedDisplayStr(resultCodeCheck));
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: _appColorTheme.appBarBackgroundColor,
        appBar: MainAppBar(
          theme: _theme,
          backgroundColor: _appColorTheme.appBarBackgroundColor,
          title: '绑定提现账号',
          leading: IconButton(
            icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
            onPressed: () => BaseViewModel.popPage(context),
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [Text('基本信息',
                      style: TextStyle(
                        fontSize: 14,
                        color: _appColorTheme.withdrawAccountBindPrimaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Container(
                      width: double.infinity,
                      decoration: _appBoxDecorationTheme.withdrawAccountBoxDecoration,
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(12.0),
                      //   color: Colors.white,
                      // ),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('姓名',
                            style: TextStyle(
                              fontSize: 14,
                              color: _appColorTheme.withdrawAccountBindPrimaryTextColor
                            ),
                          ),
                          Text(widget.existWithdrawSearchPaymentRes.realName!,
                            style: TextStyle(
                              fontSize: 12,
                              color: _appColorTheme.withdrawAccountBindSecondaryTextColor
                            ),
                          ),
                          const SizedBox(height: 13),
                          Text('身分证号',
                            style: TextStyle(
                              fontSize: 14,
                              color: _appColorTheme.withdrawAccountBindPrimaryTextColor
                            ),
                          ),
                          Text(widget.existWithdrawSearchPaymentRes.idCard!,
                            style: TextStyle(
                              fontSize: 12,
                              color: _appColorTheme.withdrawAccountBindSecondaryTextColor
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 19),
                    Text('账号信息',
                      style: TextStyle(
                        fontSize: 14,
                        color: _appColorTheme.withdrawAccountBindPrimaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Container(
                      decoration: _appBoxDecorationTheme.withdrawAccountBoxDecoration,
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('账号类型',
                            style: TextStyle(
                              fontSize: 14,
                              color: _appColorTheme.withdrawAccountBindPrimaryTextColor,
                            ),
                          ),
                          Text(_getWithdrawAccountBrandName(widget.accountType),
                            style: TextStyle(
                              fontSize: 12,
                              color: _appColorTheme.withdrawAccountBindSecondaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 13),
                          Text('提现账号',
                            style: TextStyle(
                              fontSize: 14,
                              color: _appColorTheme.withdrawAccountBindPrimaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          RoundedTextField(
                            margin: EdgeInsets.zero,
                            radius: 8,
                            textEditingController: _accountTextEditController,
                            textInputType: TextInputType.number,
                            textAlign: TextAlign.center,
                            hint: '请输入您的${_getWithdrawAccountBrandName(widget.accountType)}账号',
                            hintTextStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppColors.mainGrey,
                            ),
                            onChange: (text) {
                              setState(() {

                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 19),
                    Text('说明',
                      style: TextStyle(
                        fontSize: 14,
                        color: _appColorTheme.withdrawAccountBindPrimaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('• 请确保基本信息及账号信息为同一人，否则会影响您的提现进度',
                        style: TextStyle(
                          fontSize: 12,
                          color: _appColorTheme.withdrawAccountBindPrimaryTextColor
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text('• 如在提现过程中有任何疑问，请即时联系',
                          style: TextStyle(
                            fontSize: 12,
                            color: _appColorTheme.withdrawAccountBindPrimaryTextColor
                          ),
                        ),
                        //Todo: Link?
                        Text('客服',
                          style: TextStyle(
                            fontSize: 12,
                            color: _appColorTheme.withdrawAccountBindLinkTextColor
                          ),
                        ),
                        Text('处理',
                          style: TextStyle(
                            fontSize: 12,
                            color: _appColorTheme.withdrawAccountBindPrimaryTextColor
                          ),
                        ),
                      ],
                    ),
                  ],),
                ),

                //保存按鈕
                _saveButton()
                // Expanded(
                //   child: Align(
                //     alignment: Alignment.bottomCenter,
                //     child: SizedBox(
                //       child: GradientButton(
                //         text: '保存',
                //         textStyle:
                //             const TextStyle(color: Colors.white, fontSize: 14),
                //         radius: 24,
                //         gradientColorBegin: const Color.fromRGBO(255, 49, 121, 1),
                //         gradientColorEnd: const Color.fromRGBO(255, 49, 121, 1),
                //         height: 48,
                //         //border: border,
                //         onPressed: () {
                //           // viewModel.api_9_7(responseCodeApi_9_7[widget.editType]!, textEditController.text, widget.bankType);
                //           Navigator.pop(context);
                //         },
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
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

  Widget _saveButton(){

    Decoration btnDecoration = _appBoxDecorationTheme.btnDisableBoxDecoration;
    Color textColor = _appColorTheme.btnDisableTextColor;

    if(_accountTextEditController.text.isNotEmpty){
      btnDecoration = _appBoxDecorationTheme.btnConfirmBoxDecoration;
      textColor = _appColorTheme.btnConfirmTextColor;
    }

    return GestureDetector(
      onTap: () async {
        if(_accountTextEditController.text.isNotEmpty){
          Loading.show(context, '保存中...');
          await _wsWithdrawSaveAlipay_9_7(
          function:  widget.existWithdrawPaymentListInfo != null ? 'update' : 'save',
          account: _accountTextEditController.text,
          type: widget.accountType,
          status: widget.existWithdrawPaymentListInfo != null ? widget.existWithdrawPaymentListInfo!.status! : 1,
          );
          if (mounted) {
            Loading.hide(context);
            Navigator.of(context).pop();
          }
        }
      },
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: btnDecoration,
        child: Center(
          child: Text('保存', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: textColor)),
        ),
      ),
    );
  }
}