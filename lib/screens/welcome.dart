import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/req/member_login_req.dart';
import 'package:frechat/screens/home/home.dart';
import 'package:frechat/screens/launch/launch.dart';
import 'package:frechat/screens/personal_information/personal_information.dart';
import 'package:frechat/screens/phone_login/phone_login.dart';
import 'package:frechat/screens/phone_login/phone_login_view_model.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/assets_path/assets_txt_path.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/jiguang_mob_auth/jiguang_mob_auth.dart';
import 'package:frechat/system/ntesdun/ntesdun_mob_auth.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/loading_dialog/loading_widget.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/buttons/gradient_button.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/textfromasset/textfromasset_widget.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_txt_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

enum LoginType {
  oneClickLogin,
  otherLogin,
}

class Welcome extends ConsumerStatefulWidget {
  const Welcome({
    Key? key,
  }) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends ConsumerState<Welcome> {
  final String f_result_key = "result";

  /// 错误码
  final String f_code_key = "code";

  /// 回调的提示信息，统一返回 flutter 为 message
  final String f_msg_key = "message";

  /// 运营商信息
  final String f_opr_key = "operator";

  double get statusBarHeight => MediaQuery.of(context).padding.top;

  double get topPadding => 60 - statusBarHeight;
  final String htmlFilePath = 'assets/html/useragreement.html';
  // bool canUseOneClickLogin = true;
  late PhoneLoginViewModel viewModel;
  double baibaiTimes = 5;
  bool canChooseEnv = false;
  String selectedOption = AppEnvType.Dev.name;
  int tapCount = 0; //点击十下可打开下拉切换环境选单
  bool isCheckPrivcyAgreement = false;
  late AppTheme _theme;

  @override
  void initState() {
    super.initState();
    viewModel = PhoneLoginViewModel(ref: ref, setState: setState);
    NTESDUNMobAuth.isInitSuccess(context);
    // judgeNetWork();
    setSelectedOptopn();
    // startListening();
  }

  Future<void> setSelectedOptopn() async {
    String env = GlobalData.cacheEnvStr;
    isCheckPrivcyAgreement = await FcPrefs.getIsCheckPrivcyAgreement();
    if (env.isNotEmpty) {
      selectedOption = env;
    }
    setState(() {});
  }

  // void startListening() {
  //   gyroscopeEventStream().listen((GyroscopeEvent event) {
  //     // 调整阈值以提高灵敏度
  //     if (event.x < -3.0 && event.y.abs() < 1.5 && event.z.abs() < 1.5) {
  //       // 这里只是一个简单的示例条件，实际应用中可能需要调整阈值和条件
  //       if(baibaiTimes == 0){
  //         BaseViewModel.showToast(context, '亲～您可以切换环境罗');
  //         setState(() {
  //           canChooseEnv = true;
  //         });
  //       }else{
  //         BaseViewModel.showToast(context, '加油!!再拜拜$baibaiTimes次即可开启切换环境');
  //         baibaiTimes--;
  //         print("还须拜拜次数: $baibaiTimes");
  //       }
  //     }
  //   });
  // }

  void openTextFromAssetWidget(String filePath, String title) {
    BaseViewModel.pushPage(context, TextFromAssetWidget(title: title, filePath: filePath));
  }

  // Future<void> judgeNetWork() async {
  //   final connectivityResult = await (Connectivity().checkConnectivity());
  //   // JIGUANGMobAuth.initPlatformState();
  //
  //
  //   if (Platform.isIOS) {
  //     canUseOneClickLogin = false;
  //     setState(() {});
  //     return;
  //   }
  //
  //   if (connectivityResult != ConnectivityResult.mobile) {
  //     canUseOneClickLogin = false;
  //     setState(() {});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppImageTheme appImageTheme = _theme.getAppImageTheme;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(appImageTheme.logingBg),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            (canChooseEnv)
                ? Positioned(
                    top: 10,
                    right: 10,
                    child: Material(
                      child: DropdownButton<String>(
                        value: selectedOption,
                        onChanged: (String? newValue) async {
                          setState(() {
                            selectedOption = newValue!;
                          });
                          if (AppEnvType.Dev.name == newValue) {
                            GlobalData.cacheEnvStr = AppEnvType.Dev.name;
                          } else if (AppEnvType.QA.name == newValue) {
                            GlobalData.cacheEnvStr = AppEnvType.QA.name;
                          } else if (AppEnvType.Review.name == newValue) {
                            GlobalData.cacheEnvStr = AppEnvType.Review.name;
                          } else if (AppEnvType.Production.name == newValue) {
                            GlobalData.cacheEnvStr = AppEnvType.Production.name;
                          }
                          initializeGlobalStuffs(ref);
                        },
                        style: const TextStyle(
                          color: Colors.blue, // 修改文本颜色
                          fontSize: 16, // 修改文本大小
                        ),
                        items: <String>[
                          AppEnvType.Dev.name,
                          AppEnvType.QA.name,
                          AppEnvType.Review.name,
                          AppEnvType.Production.name
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ))
                : Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      child: Container(
                          width: 150, height: 150, color: Colors.transparent),
                      onTap: () {
                        tapCount++;
                        if (tapCount == 20) {
                          developerPasswordTextField();
                        }
                      },
                    )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: EdgeInsets.only(top: topPadding, left: 24),
                //   child: const Image(
                //     width: 32,
                //     height: 32,
                //     image: AssetImage('assets/images/icon_china.png'),
                //   ),
                // ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 16.0,
                      right: 19.5,
                      left: 19.5,
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          loginButton(),
                          otherLoginButton(),
                          bottomText(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  ///下拉选单前密码输入框
  void developerPasswordTextField() {
    CheckDialog.show(context,
        appTheme: _theme,
        titleText: '输入密码',
        barrierDismissible: false,
        showInputField: true,
        inputFieldHintText: '请输入密码…',
        showCancelButton: true,
        cancelButtonText: '取消',
        confirmButtonText: '确定', onInputConfirmPress: (text) async {
      if (text == '!2345Qwert') {
        setState(() {
          canChooseEnv = true;
        });
      } else {
        tapCount = 0;
      }
    }, onCancelPress: () {
      tapCount = 0;
    });
  }

  // 登入按鈕
  Widget loginButton() {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppLinearGradientTheme appLinearGradientTheme = theme.getAppLinearGradientTheme;
    final AppTextTheme appTextTheme = theme.getAppTextTheme;
    final AppColorTheme appColorTheme = theme.getAppColorTheme;

    return Container(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Expanded(
            child: GradientButton(
              radius: 24,
              height: 48.h,
              text: '本机号码一键登录',
              gradientColorBegin: appLinearGradientTheme.buttonPrimaryColor.colors[0],
              gradientColorEnd: appLinearGradientTheme.buttonPrimaryColor.colors[1],
              alignmentBegin: Alignment.topCenter,
              alignmentEnd: Alignment.bottomCenter,
              textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: appColorTheme.btnConfirmTextColor
              ),
              onPressed: () {
                if (isCheckPrivcyAgreement) {
                  NTESDUNLogin();
                  // JIGUANGLogin();
                } else {
                  showConfirmDialog(LoginType.oneClickLogin);
                }
                // if (canUseOneClickLogin) {
                //
                // } else {
                //   BaseViewModel.showToast(context, '未符合一键登录条件');
                // }
              },
            ),
          ),
        ],
      ),
    );
  }

  // 其他登录方式登入按鈕
  Widget otherLoginButton() {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppLinearGradientTheme appLinearGradientTheme = theme.getAppLinearGradientTheme;
    final AppTextTheme appTextTheme = theme.getAppTextTheme;
    return Container(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Expanded(
            child: GradientButton(
                radius: 24,
                height: 48.h,
                text: '其他登录方式',
                gradientColorBegin:
                    appLinearGradientTheme.buttonSecondaryColor.colors[0],
                gradientColorEnd:
                    appLinearGradientTheme.buttonSecondaryColor.colors[1],
                alignmentBegin:
                    appLinearGradientTheme.buttonSecondaryColor.begin,
                alignmentEnd: appLinearGradientTheme.buttonSecondaryColor.end,
                textStyle: appTextTheme.buttonSecondaryTextStyle,
                onPressed: () async {
                  if (isCheckPrivcyAgreement) {
                    await FcPrefs.setLoginType("");
                    BaseViewModel.pushPage(context, const PhoneLogin());
                  } else {
                    showConfirmDialog(LoginType.otherLogin);
                    // BaseViewModel.showToast(context, '请阅读并同意用户协议和隐私政策');
                  }
                }),
          ),
        ],
      ),
    );
  }

  // 底部文字(用戶協議、隱私協議）
  Widget bottomText() {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppTextTheme appTextTheme = theme.getAppTextTheme;
    final AppImageTheme appImageTheme = theme.getAppImageTheme;
    final AppTxtTheme appTxtTheme = theme.getAppTxtTheme;


    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                isCheckPrivcyAgreement = !isCheckPrivcyAgreement;
                FcPrefs.setIsCheckPrivcyAgreement(isCheckPrivcyAgreement);
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 4, top: 4, bottom: 4),
              child: ImgUtil.buildFromImgPath(
                isCheckPrivcyAgreement ? appImageTheme.iconAgreeCheck : appImageTheme.iconAgreeUncheck,
                size: 18.w
              ),
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: Text(
                '登录即代表我已阅读并同意',
                style: appTextTheme.loginAgreeTextStyle
            ),
          ),
          GestureDetector(
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                '《${AppConfig.appName}用户服务协议》',
                style: appTextTheme.protocolTextStyle,
              ),
            ),
            onTap: () {
              openTextFromAssetWidget(appTxtTheme.userAgreement, '${AppConfig.appName}用户服务协议');
            },
          ),
          Material(
            type: MaterialType.transparency,
            child: Text(
                '和',
                style: appTextTheme.loginAgreeTextStyle
            ),
          ),
          GestureDetector(
            child: Material(
              type: MaterialType.transparency,
              child: Text('《${AppConfig.appName}隐私政策》', style: appTextTheme.protocolTextStyle),

            ),
            onTap: () {
              openTextFromAssetWidget(appTxtTheme.privacyAgreement, '${AppConfig.appName}隐私政策');
            },
          ),
        ],
      ),
    );
  }

  // ZEGO init
  void _initZego() async {
    String? resultCodeCheck;
    final res = await viewModel.getRTMToken(context,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg);
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      final bool initZegoRes = await ref
          .read(authenticationProvider)
          .initZego(wsAccountGetRTMTokenRes: res);
      if (initZegoRes) {
        if (mounted)
          BaseViewModel.pushAndRemoveUntil(
              context, const Home(showAdvertise: true));
      } else {
        ref.read(authenticationProvider).logout(
            onConnectSuccess: (succMsg) =>
                BaseViewModel.pushAndRemoveUntil(context, GlobalData.launch ??  const Launch()),
            onConnectFail: (errMsg) =>
                BaseViewModel.showToast(context, errMsg));
      }
    }
  }

  void NTESDUNLogin() async {
    Loading.show(context, "一键登入登录中");
    bool preLoginRes = await NTESDUNMobAuth.preLogin(context);
    if(preLoginRes){

      bool quickLoginRes =await NTESDUNMobAuth.quickLogin(context);
      if(quickLoginRes){
        Loading.hide(context);
        Loading.show(context, "登录中");
        final String envStr = await AppConfig.getEnvStr();
        await FcPrefs.setLoginType("2");
        MemberLoginReq req = MemberLoginReq.create(
            env: envStr, //環境
            phoneToken: '', //一鍵登入Token
            deviceModel: await AppConfig.getDevice(), //设备型号
            currentVersion: AppConfig.appVersion, //当前版本号
            systemVersion: AppConfig.buildNumber,
            express: false,
            type: 1,
            tdata: '',
            phoneNumber: '',
            osType: 1,
            tokenType: '2',
            token1: NTESDUNMobAuth.tokenList[0],
            token2: NTESDUNMobAuth.tokenList[1],
            merchant: await AppConfig.getMerChant(),
            version: AppConfig.appVersion
        );
        ref.read(authenticationProvider).loginAndConnectWs(
            req: req,
            onConnectSuccess: (succMsg) async {
              /// 登入成功，只有登入頁登入需要多存這兩個參數
              await ref.read(userUtilProvider.notifier).setDataToPrefs(loginData: req.data, phoneNumber: '');
              /// 註冊完成, 載入資料
              await ref.read(authenticationProvider).preload(context);
              _initZego();
            },
            onConnectFail: (errMsg) {
              if (errMsg == ResponseCode.CODE_ACCOUNT_NOT_FOUND) {
                Loading.hide(context);
                BaseViewModel.pushPage(context, const PersonalInformation());
              } else {
                if (errMsg == '117') {
                  BaseViewModel.showToast(context, '动态验证码错误，请重新输入');
                } else {
                  BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
                }
              }
            });
      }else{
        Loading.hide(context);
        CheckDialog.show(context,
            appTheme: _theme,
            titleText: '提示', messageText: '不支持一键登入，请改用其它登录方式(一键登入失败)');
      }
    }else{
      Loading.hide(context);
      CheckDialog.show(context,
          appTheme: _theme,
          titleText: '提示', messageText: '不支持一键登入，请改用其它登录方式(预取号失败)');
    }
  }

  // 極光一鍵登入
//   void JIGUANGLogin() {
//     JIGUANGMobAuth.jVerify.checkVerifyEnable().then((map) {
//       bool result = map[f_result_key];
//       if (result) {
//         final screenSize = MediaQuery.of(context).size;
//         final screenWidth = screenSize.width;
//         final screenHeight = screenSize.height;
//         bool isiOS = Platform.isIOS;
//
//         /// 自定义授权的 UI 界面，以下设置的图片必须添加到资源文件里，
//         /// android项目将图片存放至drawable文件夹下，可使用图片选择器的文件名,例如：btn_login.xml,入参为"btn_login"。
//         /// ios项目存放在 Assets.xcassets。
//         ///
//         JVUIConfig uiConfig = JVUIConfig();
//         // uiConfig.authBGGifPath = "main_gif";
//         // uiConfig.authBGVideoPath="main_vi";
//         // uiConfig.authBGVideoPath =
//         //     "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
//         // uiConfig.authBGVideoImgPath = "main_v_bg";
//
//         //uiConfig.navHidden = true;
//         uiConfig.navColor = AppColors.mainPink.value;
//         uiConfig.navText = "";
//         uiConfig.navTextColor = Colors.blue.value;
//         uiConfig.navReturnImgPath = "return_bg"; //图片必须存在
//         uiConfig.navHidden = false;
//         uiConfig.navReturnBtnHidden = true;
//
//         uiConfig.logoWidth = 48;
//         uiConfig.logoHeight = 48;
//         //uiConfig.logoOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.logoWidth/2).toInt();
//         uiConfig.logoOffsetY = 20;
//         uiConfig.logoVerticalLayoutItem = JVIOSLayoutItem.ItemSuper;
//         // uiConfig.logoHidden = true;
//         uiConfig.logoImgPath = "logo";
//
//         uiConfig.numberFieldWidth = 200;
//         uiConfig.numberFieldHeight = 40;
//         //uiConfig.numFieldOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.numberFieldWidth/2).toInt();
//         uiConfig.numFieldOffsetY = isiOS ? 20 : 120;
//         uiConfig.numberVerticalLayoutItem = JVIOSLayoutItem.ItemLogo;
//         uiConfig.numberColor = uiConfig.navColor;
//         uiConfig.numberSize = 18;
//
//         uiConfig.sloganOffsetY = isiOS ? 20 : 160;
//         uiConfig.sloganVerticalLayoutItem = JVIOSLayoutItem.ItemNumber;
//         uiConfig.sloganTextColor = Colors.black.value;
//         uiConfig.sloganTextSize = 15;
// //        uiConfig.slogan
//         //uiConfig.sloganHidden = 0;
//
//         uiConfig.logBtnWidth = 148;
//         uiConfig.logBtnHeight = 44;
//         //uiConfig.logBtnOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.logBtnWidth/2).toInt();
//         uiConfig.logBtnOffsetY = isiOS ? 120 : 530;
//         // uiConfig.logBtnBottomOffsetY = 10;
//         uiConfig.logBtnVerticalLayoutItem = JVIOSLayoutItem.ItemSlogan;
//         uiConfig.logBtnText = "登录";
//         uiConfig.logBtnTextColor = Colors.white.value;
//         uiConfig.logBtnTextSize = 16;
//         uiConfig.logBtnTextBold = true;
//         uiConfig.logBtnBackgroundPath = "login";
//         uiConfig.loginBtnNormalImage = "login"; //图片必须存在
//         uiConfig.loginBtnPressedImage = "login"; //图片必须存在
//         uiConfig.loginBtnUnableImage = "login"; //图片必须存在
//
//         uiConfig.privacyHintToast =
//             true; //only android 设置隐私条款不选中时点击登录按钮默认显示toast。
//
//         // uiConfig.privacyState = false; //设置默认勾选
//         // uiConfig.privacyCheckboxSize = 20;
//         // uiConfig.checkedImgPath = "check_image"; //图片必须存在
//         // uiConfig.uncheckedImgPath = "uncheck_image"; //图片必须存在
//         // uiConfig.privacyCheckboxInCenter = true;
//         // uiConfig.privacyCheckboxHidden = false;
//         // uiConfig.isAlertPrivacyVc = true;
//         // // //
//         // //uiConfig.privacyOffsetX = isiOS ? (20 + uiConfig.privacyCheckboxSize) : null;
//         // uiConfig.privacyOffsetY = 50; // 距离底部距离
//         // uiConfig.privacyVerticalLayoutItem =
//         //     JVIOSLayoutItem.ItemSuper;
//         // uiConfig.clauseName = "协议1";
//         // uiConfig.clauseUrl = "http://www.baidu.com";
//         // uiConfig.clauseBaseColor = Colors.black.value;
//         // uiConfig.clauseNameTwo = "协议二";
//         // uiConfig.clauseUrlTwo = "http://www.hao123.com";
//         // uiConfig.clauseColor = uiConfig.navColor;
//         // uiConfig.privacyText = ["1极", "4证"];
//         // uiConfig.privacyTextSize = 13;
//         // uiConfig.privacyItem = [
//         //   JVPrivacy("自定义协议1", "http://www.baidu.com",
//         //       beforeName: "==", afterName: "++", separator: "*"),
//         //   JVPrivacy("自定义协议2", "http://www.baidu.com",
//         //       separator: "、"),
//         //   JVPrivacy("自定义协议3", "http://www.baidu.com",
//         //       separator: "、"),
//         //   JVPrivacy("自定义协议4", "http://www.baidu.com",
//         //       separator: "、"),
//         //   JVPrivacy("自定义协议5", "http://www.baidu.com",
//         //       separator: "、")
//         // ];
//         // // uiConfig.textVerAlignment = 1;
//         // uiConfig.privacyWithBookTitleMark = true;
//         // uiConfig.privacyTextCenterGravity = true;
//         uiConfig.authStatusBarStyle = JVIOSBarStyle.StatusBarStyleDarkContent;
//         uiConfig.privacyStatusBarStyle = JVIOSBarStyle.StatusBarStyleDefault;
//         uiConfig.modelTransitionStyle =
//             JVIOSUIModalTransitionStyle.CrossDissolve;
//
//         uiConfig.statusBarColorWithNav = true;
//         uiConfig.virtualButtonTransparent = true;
//
//         uiConfig.privacyStatusBarColorWithNav = true;
//         uiConfig.privacyVirtualButtonTransparent = true;
//
//         uiConfig.needStartAnim = true;
//         uiConfig.needCloseAnim = true;
//         uiConfig.enterAnim = "activity_slide_enter_bottom";
//         uiConfig.exitAnim = "activity_slide_exit_bottom";
//
//         uiConfig.privacyNavColor = Colors.white.value;
//         uiConfig.privacyNavTitleTextColor = Colors.blue.value;
//         uiConfig.privacyNavTitleTextSize = 16;
//
//         uiConfig.privacyNavTitleTitle = "ios lai le"; //only ios
//         uiConfig.privacyNavReturnBtnImage = "back"; //图片必须存在;
//
//         // //协议二次弹窗内容设置 -iOS
//         // uiConfig.agreementAlertViewTitleTexSize = 18;
//         // uiConfig.agreementAlertViewTitleTextColor = Colors.red.value;
//         // uiConfig.agreementAlertViewContentTextAlignment =
//         //     JVTextAlignmentType.center;
//         // uiConfig.agreementAlertViewContentTextFontSize = 16;
//         // uiConfig.agreementAlertViewLoginBtnNormalImagePath =
//         //     "login_btn_normal";
//         // uiConfig.agreementAlertViewLoginBtnPressedImagePath =
//         //     "login_btn_press";
//         // uiConfig.agreementAlertViewLoginBtnUnableImagePath =
//         //     "login_btn_unable";
//         // uiConfig.agreementAlertViewLogBtnTextColor = Colors.black.value;
//         //
//         // //协议二次弹窗内容设置 -Android
//         JVPrivacyCheckDialogConfig privacyCheckDialogConfig =
//             JVPrivacyCheckDialogConfig();
//         // privacyCheckDialogConfig.width = 250;
//         //  privacyCheckDialogConfig.height = 100;
//         privacyCheckDialogConfig.offsetX = 0;
//         privacyCheckDialogConfig.offsetY = 0;
//         privacyCheckDialogConfig.titleTextSize = 22;
//         privacyCheckDialogConfig.gravity = "center";
//         privacyCheckDialogConfig.titleTextColor = Colors.black.value;
//         privacyCheckDialogConfig.contentTextGravity = "left";
//         privacyCheckDialogConfig.contentTextSize = 14;
//         privacyCheckDialogConfig.logBtnImgPath = "login";
//         privacyCheckDialogConfig.logBtnTextColor = Colors.white.value;
//         uiConfig.privacyCheckDialogConfig = privacyCheckDialogConfig;
//
//         uiConfig.setIsPrivacyViewDarkMode = false; //协议页面是否支持暗黑模式
//
//         //弹框模式
//         // JVPopViewConfig popViewConfig = JVPopViewConfig();
//         // popViewConfig.width = (screenWidth - 100.0).toInt();
//         // popViewConfig.height = (screenHeight - 150.0).toInt();
//         //
//         // uiConfig.popViewConfig = popViewConfig;
//
//         /// 添加自定义的 控件 到授权界面
//         List<JVCustomWidget> widgetList = [];
//
//         final String text_widgetId = "jv_add_custom_text"; // 标识控件 id
//         JVCustomWidget textWidget =
//             JVCustomWidget(text_widgetId, JVCustomWidgetType.textView);
//         textWidget.title = "新加 text view 控件";
//         textWidget.left = 20;
//         textWidget.top = 360;
//         textWidget.width = 200;
//         textWidget.height = 40;
//         textWidget.backgroundColor = Colors.yellow.value;
//         textWidget.isShowUnderline = true;
//         textWidget.textAlignment = JVTextAlignmentType.center;
//         textWidget.isClickEnable = true;
//
//         // 添加点击事件监听
//         // jverify.addClikWidgetEventListener(text_widgetId, (eventId) {
//         //   print("receive listener - click widget event :$eventId");
//         //   if (text_widgetId == eventId) {
//         //     print("receive listener - 点击【新加 text】");
//         //   }
//         // });
//         // widgetList.add(textWidget);
//         //
//         // final String btn_widgetId = "jv_add_custom_button"; // 标识控件 id
//         // JVCustomWidget buttonWidget =
//         //     JVCustomWidget(btn_widgetId, JVCustomWidgetType.button);
//         // buttonWidget.title = "新加 button 控件";
//         // buttonWidget.left = 100;
//         // buttonWidget.top = 400;
//         // buttonWidget.width = 150;
//         // buttonWidget.height = 40;
//         // buttonWidget.isShowUnderline = true;
//         // buttonWidget.backgroundColor = Colors.brown.value;
//         // //buttonWidget.btnNormalImageName = "";
//         // //buttonWidget.btnPressedImageName = "";
//         // //buttonWidget.textAlignment = JVTextAlignmentType.left;
//         //
//         // // 添加点击事件监听
//         // jverify.addClikWidgetEventListener(btn_widgetId, (eventId) {
//         //   print("receive listener - click widget event :$eventId");
//         //   if (btn_widgetId == eventId) {
//         //     print("receive listener - 点击【新加 button】");
//         //   }
//         // });
//         // widgetList.add(buttonWidget);
//
//         /// 步骤 1：调用接口设置 UI
//         ///
//         JVUIConfig uiConfig2 = JVUIConfig();
//         // jverify.setCustomAuthViewAllWidgets(uiConfig2, widgets: widgetList);
//         JIGUANGMobAuth.jVerify.setCustomAuthorizationView(true, uiConfig,
//             landscapeConfig: uiConfig, widgets: widgetList);
//
//         /// 步骤 2：调用一键登录接口
//
//         /// 方式一：使用同步接口 （如果想使用异步接口，则忽略此步骤，看方式二）
//         /// 先，添加 loginAuthSyncApi 接口回调的监听
//         String token = '';
//         JIGUANGMobAuth.jVerify.addLoginAuthCallBackListener((event) {
//           ///这里的messaage就是token
//           if(event.code != 2000){
//             CheckDialog.show(context,
//                 titleText: '提示', messageText: '不支持一键登入，请改用其它登录方式');
//             return;
//           }
//           setState(() {});
//           token = event.message!;
//           FcPrefs.setVerificationCode(token);
//           Loading.show(context, "登录中");
//           JIGUANGMobAuth.login(token, ref, onConnectSuccess: (succ) async {
//             /// 註冊完成, 載入資料
//             await ref.read(authenticationProvider).preload(context);
//
//             _initZego();
//           }, onConnectFail: (errMsg) {
//             Loading.hide(context);
//             if (errMsg == '117') {
//               BaseViewModel.showToast(context, '动态验证码错误，请重新输入');
//             } else {
//               BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
//             }
//           }, onConnectRegister: () {
//             Loading.hide(context);
//             BaseViewModel.pushPage(context, const PersonalInformation());
//           });
//           print(
//               "通过添加监听，获取到 loginAuthSyncApi 接口返回数据，code=${event.code},message = ${event.message},operator = ${event.operator}");
//         });
//
//         /// 再，执行同步的一键登录接口
//         JIGUANGMobAuth.jVerify.loginAuthSyncApi(autoDismiss: true);
//       }
//     });
//   }

  // 跳出同意彈窗
  void showConfirmDialog(LoginType loginType) {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppTextTheme appTextTheme = theme.getAppTextTheme;
    final AppLinearGradientTheme appLinearGradientTheme = theme.getAppLinearGradientTheme;
    final AppColorTheme appColorTheme = theme.getAppColorTheme;
    final AppBoxDecorationTheme appBoxDecorationTheme = theme.getAppBoxDecorationTheme;
    final AppTxtTheme appTxtTheme = theme.getAppTxtTheme;

    CommDialog(context).build(
      theme: _theme,
        title: '温馨提示',
        backgroundColor: appColorTheme.dialogBackgroundColor,
        leftLinearGradient: appLinearGradientTheme.buttonSecondaryColor,
        rightLinearGradient: appLinearGradientTheme.buttonPrimaryColor,
        leftTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: appColorTheme.btnCancelTextColor
        ),
        rightTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: appColorTheme.btnConfirmTextColor
        ),
        contentDes: '',
        widget: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              '登录即代表我已阅读并同意',
              style: appTextTheme.loginAgreeTextStyle,
            ),
            GestureDetector(
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  '《${AppConfig.appName}用户服务协议》',
                  style: appTextTheme.protocolTextStyle,
                ),
              ),
              onTap: () {
                openTextFromAssetWidget(appTxtTheme.userAgreement, '${AppConfig.appName}用户服务协议');
              },
            ),
            Text(
              '和',
              style: appTextTheme.loginAgreeTextStyle,
            ),
            GestureDetector(
              child: Material(
                type: MaterialType.transparency,
                child: Text('《${AppConfig.appName}隐私政策》',
                    style: appTextTheme.protocolTextStyle),
              ),
              onTap: () {
                openTextFromAssetWidget(appTxtTheme.privacyAgreement, '${AppConfig.appName}隐私政策');
              },
            ),
          ],
        ),
        leftBtnTitle: '不同意',
        rightBtnTitle: '同意',
        leftAction: () {
          BaseViewModel.popPage(context);
        },
        rightAction: () {
          setState(() {
            isCheckPrivcyAgreement = !isCheckPrivcyAgreement;
            FcPrefs.setIsCheckPrivcyAgreement(isCheckPrivcyAgreement);
          });
          BaseViewModel.popPage(context);
          if (loginType == LoginType.oneClickLogin) {
            // JIGUANGLogin();
          } else {
            BaseViewModel.pushPage(context, const PhoneLogin());
          }
        });
  }
}
