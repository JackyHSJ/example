import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frechat/screens/home/home.dart';
import 'package:frechat/screens/launch/launch.dart';
import 'package:frechat/screens/launch/launch_view_model.dart';
import 'package:frechat/screens/personal_information/personal_information.dart';
import 'package:frechat/screens/phone_login/phone_login_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/jiguang_mob_auth/jiguang_mob_auth.dart';
import 'package:frechat/system/ntesdun/ntesdun_mob_auth.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/loading_dialog/loading_widget.dart';
import 'package:frechat/widgets/shared/buttons/gradient_button.dart';
import 'package:frechat/widgets/shared/rounded_textfield.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';


class PhoneLogin extends ConsumerStatefulWidget {
  const PhoneLogin({Key? key}) : super(key: key);

  @override
  ConsumerState<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends ConsumerState<PhoneLogin> {
  late LaunchViewModel launchViewModel;

  // static const platform = MethodChannel('example.com/channel');
  late PhoneLoginViewModel viewModel;
  late AppTheme _theme;
  late AppColorTheme appColorTheme;
  late AppTextTheme appTextTheme;
  late AppLinearGradientTheme appLinearGradientTheme;
  late AppImageTheme appImageTheme;

  @override
  void initState() {
    super.initState();
    launchViewModel = LaunchViewModel(ref: ref);
    viewModel = PhoneLoginViewModel(ref: ref, setState: setState);
    viewModel.phoneInputFocus.addListener(() => _onTextFieldFocusChange(viewModel.phoneInputFocus));
    viewModel.verificationCodeInputFocus.addListener(
            () => _onTextFieldFocusChange(viewModel.verificationCodeInputFocus)
    );
    showCachedNumber();
  }

  Future<void> showCachedNumber() async {
    String phoneNumber = await FcPrefs.getPhoneNumber();
    viewModel.phoneController.text = phoneNumber;
  }

  @override
  void dispose() {
    viewModel.phoneController.dispose();
    viewModel.phoneInputFocus.dispose();
    viewModel.verificationCodeController.dispose();
    viewModel.verificationCodeInputFocus.dispose();
    super.dispose();
  }

  void _onTextFieldFocusChange(FocusNode focusNode) {
    if (!focusNode.hasFocus) {
      // 第一个文本框失去焦点的逻辑处理
      setState(() {});
    }
  }

  bool checkButton() {
    if (viewModel.phoneController.text.isNotEmpty) {
      if (viewModel.verificationCodeController.text.isNotEmpty) {
        return true;
      }
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appColorTheme = _theme.getAppColorTheme;
    appImageTheme = _theme.getAppImageTheme;
    appTextTheme = _theme.getAppTextTheme;
    appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "手机快速登录",
          style: appTextTheme.appbarTextStyle,
        ),
        backgroundColor: appColorTheme.appBarBackgroundColor,
        centerTitle: true,
        leading: GestureDetector(
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Image(
              image: AssetImage(appImageTheme.iconBack),
            ),
          ),
          onTap: () => BaseViewModel.popPage(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => BaseViewModel.clearAllFocus(),
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(appImageTheme.phoneLoginBg),
                fit: BoxFit.cover,
              )),
          child: Column(
            children: [
              textFieldPhoneWidget(),
              textFieldVerificationcodeWidget(),
              loginButton()
            ],
          ),
        ),
      ),
    );
  }

  //電話號碼輸入框
  Widget textFieldPhoneWidget() {
    return Container(
      padding: const EdgeInsets.only(top: 32),
      child: RoundedTextField(
        textEditingController: viewModel.phoneController,
        focusNode: viewModel.phoneInputFocus,
        focusBorderColor: appColorTheme.textFieldFocusingColor,
        textInputType: TextInputType.number,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(9),
          child: Image(
            image: AssetImage(appImageTheme.iconPhone),
          ),
        ),
        suffixIcon: (viewModel.phoneController.text == "")
            ? null
            : GestureDetector(
          child: const Padding(
              padding: EdgeInsets.all(12),
              child: Image(
                  image: AssetImage('assets/images/icon_cancel.png'))),
          onTap: () {
            viewModel.phoneController.clear();
          },
        ),
        hint: "请输入您的手机号",
        hintTextStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: AppColors.mainGrey,
        ),
        onChange: (text) {
          checkButton();
          setState(() {});
        },
      ),
    );
  }

  //驗證碼輸入框
  Widget textFieldVerificationcodeWidget() {
    final bool isCountDown = viewModel.smsCountDown != viewModel.countDownTimeMax;
    final String title = (isCountDown) ? '後重新获取验证码' : '获取验证码';
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: RoundedTextField(
        textEditingController: viewModel.verificationCodeController,
        focusNode: viewModel.verificationCodeInputFocus,
        focusBorderColor: appColorTheme.textFieldFocusingColor,
        textInputType: TextInputType.number,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(9),
          child: Image(
            image: AssetImage(appImageTheme.iconVerificationCode),
          ),
        ),
        suffixIcon: TextButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSMSCountDown(isCountDown),
                _buildVerifyBtn(title)
              ],
            ),
            onPressed: () {
              viewModel.getSms(context);
            }
        ),
        hint: "填写验证码",
        hintTextStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: AppColors.mainGrey,
        ),
        onChange: (text) {
          checkButton();
          setState(() {});
        },
      ),
    );
  }

  Widget _buildVerifyBtn(String title) {
    return Text(
      title,
      style: TextStyle(color: appColorTheme.verifyCodeTextColor, fontWeight: FontWeight.w600)
    );
  }

  Widget _buildSMSCountDown(bool isEnable) {
    return Offstage(
      offstage: !isEnable,
      child: Text('${viewModel.smsCountDown}s', style: TextStyle(color: appColorTheme.verifyCodeTextColor, fontWeight: FontWeight.w600)),
    );
  }

  //登陸
  Widget loginButton() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 54),
          child: GradientButton(
            radius: 24,
            height: 48.h,
            text: '登录',
            gradientColorBegin: checkButton()
                ? appLinearGradientTheme.buttonPrimaryColor.colors[0]
                : appLinearGradientTheme.buttonDisableColor.colors[0],
            gradientColorEnd: checkButton()
                ? appLinearGradientTheme.buttonPrimaryColor.colors[1]
                : appLinearGradientTheme.buttonDisableColor.colors[1],
            alignmentBegin: Alignment.topCenter,
            alignmentEnd: Alignment.bottomCenter,
            textStyle: checkButton()? appTextTheme.buttonPrimaryTextStyle:appTextTheme.buttonDisableTextStyle,
            onPressed: () async {
              if(checkButton()){
                loginButtonOnPress();
              }
              BaseViewModel.clearAllFocus();
            },
          ),
        ),
      ),
    );
  }

  //登入按鈕點擊事件
  Future<void> loginButtonOnPress() async {
    //按鈕校驗
    // BaseViewModel.clearAllFocus();
    if (viewModel.phoneController.text.length != 11) {
      Fluttertoast.showToast(
        msg: "电话号码长度有误",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[700],
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      bool express = true;
      if(viewModel.phoneController.text!='1234'){
        express = false;
      }
      Loading.show(context, "登录中");
      NTESDUNMobAuth.loginInWithSMSOrPassword(
          context, viewModel.phoneController.text, viewModel.verificationCodeController.text, ref,express,
          onConnectSuccess: (succ) async {
            await ref.read(authenticationProvider).preload(context);
            /// 連線成功，接下來做取得RTM Token 並做 Zego init
            /// get rtc token to Login Zego
            _initZego();
          }, onConnectFail: (errMsg) {
        Loading.hide(context);
        if(errMsg == '117'){
          BaseViewModel.showToast(context, '动态验证码错误，请重新输入');
        }else{
          BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
        }
      }, onConnectRegister: () {
        Loading.hide(context);
        BaseViewModel.pushPage(context, const PersonalInformation());
      });
    }
  }

  _initZego() async {
    String? resultCodeCheck;
    final res = await viewModel.getRTMToken(context,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg
    );
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      final bool initZegoRes = await ref.read(authenticationProvider).initZego(wsAccountGetRTMTokenRes: res);
      if(initZegoRes) {
        if(mounted) BaseViewModel.pushAndRemoveUntil(context, const Home(showAdvertise: true,));
      } else {
        ref.read(authenticationProvider).logout(
            onConnectSuccess: (succMsg) => BaseViewModel.pushAndRemoveUntil(context, GlobalData.launch ??  const Launch()),
            onConnectFail: (errMsg) => BaseViewModel.showToast(context, errMsg));
      }
    }
  }
}

