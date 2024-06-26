// //這個類別包裝所有跟中國移動相關的 Android/iOS API, 供專案內需要用到的任何地方使用。
// import 'dart:io';
//
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:frechat/system/app_config/app_config.dart';
// import 'package:frechat/models/req/error_log_req.dart';
// import 'package:frechat/models/req/member_login_req.dart';
// import 'package:frechat/models/req/send_sms_req.dart';
// import 'package:frechat/models/res/member_login_res.dart';
// import 'package:frechat/system/base_view_model.dart';
// import 'package:frechat/system/global.dart';
// import 'package:frechat/system/global/shared_preferance.dart';
// import 'package:frechat/system/providers.dart';
// import 'package:frechat/system/repository/response_code.dart';
// import 'package:jverify/jverify.dart';
// import 'package:path_provider/path_provider.dart';
//
// import '../provider/user_info_provider.dart';
//
// class JIGUANGMobAuth {
//   static Jverify jVerify = Jverify();
//
//   static Future loginAuth() async {
//     //Todo :For Jerry
//     //極光一鍵登入初始化
//     initPlatformState();
//     initJverifySDK();
//     //一鍵登入
//     // preLogin();
//   }
//
//   static void test(BuildContext context, WidgetRef ref) {
//     initPlatformState();
//     initJverifySDK();
//     preLogin(context, ref);
//   }
//
//   //預取號
//   static void preLogin(BuildContext context, WidgetRef ref) {
//     Jverify jverify = Jverify();
//     jverify.checkVerifyEnable().then((map) {
//       if (map["result"]) {
//         jverify.preLogin().then((map) {
//           Fluttertoast.showToast(
//             msg: '預取號接口回調' + map["code"].toString(),
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 1,
//             backgroundColor: Colors.grey[700],
//             textColor: Colors.white,
//             fontSize: 16.0,
//           );
//           if (map["code"] == 7000) {
//             int code = map["code"];
//             Fluttertoast.showToast(
//               msg: '預取號接口回調message' + map["message"],
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.CENTER,
//               timeInSecForIosWeb: 1,
//               backgroundColor: Colors.grey[700],
//               textColor: Colors.white,
//               fontSize: 16.0,
//             );
//             oneClickLogin(context, ref);
//           }
//         });
//       } else {
//         print("[2016],msg = 当前网络环境不支持认证");
//       }
//     });
//   }
//
//   //拉起授權頁，並取得Token
//   static Future<void> oneClickLogin(BuildContext context, WidgetRef ref) async {
//     Jverify jverify = Jverify();
//     Fluttertoast.showToast(
//       msg: '拉起授權頁',
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.CENTER,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.grey[700],
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//     jverify.checkVerifyEnable().then((map) {
//       bool result = map["result"];
//       Fluttertoast.showToast(
//         msg: 'result = ' + result.toString(),
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.grey[700],
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//       try {
//         if (result) {
//           final screenSize = MediaQuery.of(context).size;
//           final screenWidth = screenSize.width;
//           final screenHeight = screenSize.height;
//           bool isiOS = Platform.isIOS;
//
//           /// 自定义授权的 UI 界面，以下设置的图片必须添加到资源文件里，
//           /// android项目将图片存放至drawable文件夹下，可使用图片选择器的文件名,例如：btn_login.xml,入参为"btn_login"。
//           /// ios项目存放在 Assets.xcassets。
//
//           Fluttertoast.showToast(
//             msg: '1',
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 1,
//             backgroundColor: Colors.grey[700],
//             textColor: Colors.white,
//             fontSize: 16.0,
//           );
//           JVUIConfig uiConfig = JVUIConfig();
//           test123('2');
//           // uiConfig.authBGGifPath = "main_gif";
//           // uiConfig.authBGVideoPath="main_vi";
//           uiConfig.authBGVideoPath =
//           "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
//           test123('3');
//           uiConfig.authBGVideoImgPath = "main_v_bg";
//           test123('4');
//           //uiConfig.navHidden = true;
//           uiConfig.navColor = Colors.red.value;
//           test123('5');
//           uiConfig.navText = "登录";
//           test123('6');
//           uiConfig.navTextColor = Colors.blue.value;
//           test123('7');
//           uiConfig.navReturnImgPath = "return_bg"; //图片必须存在
//           test123('8');
//           uiConfig.logoWidth = 100;
//           test123('9');
//           uiConfig.logoHeight = 80;
//           test123('10');
//           //uiConfig.logoOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.logoWidth/2).toInt();
//           uiConfig.logoOffsetY = 10;
//           test123('11');
//           uiConfig.logoVerticalLayoutItem = JVIOSLayoutItem.ItemSuper;
//           test123('12');
//           uiConfig.logoHidden = false;
//           test123('13');
//           uiConfig.logoImgPath = "logo";
//           test123('14');
//           uiConfig.numberFieldWidth = 200;
//           test123('15');
//           uiConfig.numberFieldHeight = 40;
//           test123('16');
//           //uiConfig.numFieldOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.numberFieldWidth/2).toInt();
//           uiConfig.numFieldOffsetY = isiOS ? 20 : 120;
//           test123('17');
//           uiConfig.numberVerticalLayoutItem = JVIOSLayoutItem.ItemLogo;
//           test123('18');
//           uiConfig.numberColor = Colors.blue.value;
//           test123('19');
//           uiConfig.numberSize = 18;
//           test123('20');
//
//           uiConfig.sloganOffsetY = isiOS ? 20 : 160;
//           uiConfig.sloganVerticalLayoutItem = JVIOSLayoutItem.ItemNumber;
//           uiConfig.sloganTextColor = Colors.black.value;
//           uiConfig.sloganTextSize = 15;
// //        uiConfig.slogan
//           //uiConfig.sloganHidden = 0;
//
//           uiConfig.logBtnWidth = 220;
//           uiConfig.logBtnHeight = 50;
//           //uiConfig.logBtnOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.logBtnWidth/2).toInt();
//           uiConfig.logBtnOffsetY = isiOS ? 20 : 230;
//           uiConfig.logBtnVerticalLayoutItem = JVIOSLayoutItem.ItemSlogan;
//           uiConfig.logBtnText = "登录按钮";
//           uiConfig.logBtnTextColor = Colors.brown.value;
//           uiConfig.logBtnTextSize = 16;
//           uiConfig.logBtnTextBold = true;
//           uiConfig.loginBtnNormalImage = "login_btn_normal"; //图片必须存在
//           uiConfig.loginBtnPressedImage = "login_btn_press"; //图片必须存在
//           uiConfig.loginBtnUnableImage = "login_btn_unable"; //图片必须存在
//
//           uiConfig.privacyHintToast =
//           true; //only android 设置隐私条款不选中时点击登录按钮默认显示toast。
//
//           uiConfig.privacyState = false; //设置默认勾选
//           uiConfig.privacyCheckboxSize = 20;
//           uiConfig.checkedImgPath = "check_image"; //图片必须存在
//           uiConfig.uncheckedImgPath = "uncheck_image"; //图片必须存在
//           uiConfig.privacyCheckboxInCenter = true;
//           uiConfig.privacyCheckboxHidden = false;
//           uiConfig.isAlertPrivacyVc = true;
//
//           //uiConfig.privacyOffsetX = isiOS ? (20 + uiConfig.privacyCheckboxSize) : null;
//           uiConfig.privacyOffsetY = 15; // 距离底部距离
//           uiConfig.privacyVerticalLayoutItem = JVIOSLayoutItem.ItemSuper;
//           uiConfig.clauseName = "协议1";
//           uiConfig.clauseUrl = "http://www.baidu.com";
//           uiConfig.clauseBaseColor = Colors.black.value;
//           uiConfig.clauseNameTwo = "协议二";
//           uiConfig.clauseUrlTwo = "http://www.hao123.com";
//           uiConfig.clauseColor = Colors.red.value;
//           uiConfig.privacyText = ["1极", "4证"];
//           uiConfig.privacyTextSize = 13;
//           uiConfig.privacyItem = [
//             JVPrivacy("自定义协议1", "http://www.baidu.com",
//                 beforeName: "==", afterName: "++", separator: "*"),
//             JVPrivacy("自定义协议2", "http://www.baidu.com", separator: "、"),
//             JVPrivacy("自定义协议3", "http://www.baidu.com", separator: "、"),
//             JVPrivacy("自定义协议4", "http://www.baidu.com", separator: "、"),
//             JVPrivacy("自定义协议5", "http://www.baidu.com", separator: "、")
//           ];
//           uiConfig.textVerAlignment = 1;
//           uiConfig.privacyWithBookTitleMark = true;
//           //uiConfig.privacyTextCenterGravity = false;
//           uiConfig.authStatusBarStyle = JVIOSBarStyle.StatusBarStyleDarkContent;
//           uiConfig.privacyStatusBarStyle = JVIOSBarStyle.StatusBarStyleDefault;
//           uiConfig.modelTransitionStyle =
//               JVIOSUIModalTransitionStyle.CrossDissolve;
//
//           uiConfig.statusBarColorWithNav = true;
//           uiConfig.virtualButtonTransparent = true;
//
//           uiConfig.privacyStatusBarColorWithNav = true;
//           uiConfig.privacyVirtualButtonTransparent = true;
//
//           uiConfig.needStartAnim = true;
//           uiConfig.needCloseAnim = true;
//           uiConfig.enterAnim = "activity_slide_enter_bottom";
//           uiConfig.exitAnim = "activity_slide_exit_bottom";
//
//           uiConfig.privacyNavColor = Colors.red.value;
//           uiConfig.privacyNavTitleTextColor = Colors.blue.value;
//           uiConfig.privacyNavTitleTextSize = 16;
//
//           uiConfig.privacyNavTitleTitle = "ios lai le"; //only ios
//           uiConfig.privacyNavReturnBtnImage = "back"; //图片必须存在;
//
//           //协议二次弹窗内容设置 -iOS
//           uiConfig.agreementAlertViewTitleTexSize = 18;
//           uiConfig.agreementAlertViewTitleTextColor = Colors.red.value;
//           uiConfig.agreementAlertViewContentTextAlignment =
//               JVTextAlignmentType.center;
//           uiConfig.agreementAlertViewContentTextFontSize = 16;
//           uiConfig.agreementAlertViewLoginBtnNormalImagePath =
//           "login_btn_normal";
//           uiConfig.agreementAlertViewLoginBtnPressedImagePath =
//           "login_btn_press";
//           uiConfig.agreementAlertViewLoginBtnUnableImagePath =
//           "login_btn_unable";
//           uiConfig.agreementAlertViewLogBtnTextColor = Colors.black.value;
//
//           //协议二次弹窗内容设置 -Android
//           JVPrivacyCheckDialogConfig privacyCheckDialogConfig =
//           JVPrivacyCheckDialogConfig();
//           // privacyCheckDialogConfig.width = 250;
//           // privacyCheckDialogConfig.height = 100;
//           privacyCheckDialogConfig.offsetX = 0;
//           privacyCheckDialogConfig.offsetY = 0;
//           privacyCheckDialogConfig.titleTextSize = 22;
//           privacyCheckDialogConfig.gravity = "center";
//           privacyCheckDialogConfig.titleTextColor = Colors.black.value;
//           privacyCheckDialogConfig.contentTextGravity = "left";
//           privacyCheckDialogConfig.contentTextSize = 14;
//           privacyCheckDialogConfig.logBtnImgPath = "login_btn_normal";
//           privacyCheckDialogConfig.logBtnTextColor = Colors.black.value;
//           uiConfig.privacyCheckDialogConfig = privacyCheckDialogConfig;
//
//           //弹框模式
//           // JVPopViewConfig popViewConfig = JVPopViewConfig();
//           // popViewConfig.width = (screenWidth - 100.0).toInt();
//           // popViewConfig.height = (screenHeight - 150.0).toInt();
//
//           // uiConfig.popViewConfig = popViewConfig;
//
//           Fluttertoast.showToast(
//             msg: '2',
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 1,
//             backgroundColor: Colors.grey[700],
//             textColor: Colors.white,
//             fontSize: 16.0,
//           );
//
//           /// 添加自定义的 控件 到授权界面
//           List<JVCustomWidget> widgetList = [];
//
//           final String text_widgetId = "jv_add_custom_text"; // 标识控件 id
//           JVCustomWidget textWidget =
//           JVCustomWidget(text_widgetId, JVCustomWidgetType.textView);
//           textWidget.title = "新加 text view 控件";
//           textWidget.left = 20;
//           textWidget.top = 360;
//           textWidget.width = 200;
//           textWidget.height = 40;
//           textWidget.backgroundColor = Colors.yellow.value;
//           textWidget.isShowUnderline = true;
//           textWidget.textAlignment = JVTextAlignmentType.center;
//           textWidget.isClickEnable = true;
//
//           // 添加点击事件监听
//           jverify.addClikWidgetEventListener(text_widgetId, (eventId) {
//             print("receive listener - click widget event :$eventId");
//             if (text_widgetId == eventId) {
//               print("receive listener - 点击【新加 text】");
//             }
//           });
//           widgetList.add(textWidget);
//
//           Fluttertoast.showToast(
//             msg: '3',
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 1,
//             backgroundColor: Colors.grey[700],
//             textColor: Colors.white,
//             fontSize: 16.0,
//           );
//
//           final String btn_widgetId = "jv_add_custom_button"; // 标识控件 id
//           JVCustomWidget buttonWidget =
//           JVCustomWidget(btn_widgetId, JVCustomWidgetType.button);
//           buttonWidget.title = "新加 button 控件";
//           buttonWidget.left = 100;
//           buttonWidget.top = 400;
//           buttonWidget.width = 150;
//           buttonWidget.height = 40;
//           buttonWidget.isShowUnderline = true;
//           buttonWidget.backgroundColor = Colors.brown.value;
//           //buttonWidget.btnNormalImageName = "";
//           //buttonWidget.btnPressedImageName = "";
//           //buttonWidget.textAlignment = JVTextAlignmentType.left;
//
//           Fluttertoast.showToast(
//             msg: '4',
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 1,
//             backgroundColor: Colors.grey[700],
//             textColor: Colors.white,
//             fontSize: 16.0,
//           );
//
//           // 添加点击事件监听
//           jverify.addClikWidgetEventListener(btn_widgetId, (eventId) {
//             print("receive listener - click widget event :$eventId");
//             if (btn_widgetId == eventId) {
//               print("receive listener - 点击【新加 button】");
//             }
//           });
//           widgetList.add(buttonWidget);
//
//           Fluttertoast.showToast(
//             msg: '5',
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 1,
//             backgroundColor: Colors.grey[700],
//             textColor: Colors.white,
//             fontSize: 16.0,
//           );
//
//           Fluttertoast.showToast(
//             msg: '6',
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 1,
//             backgroundColor: Colors.grey[700],
//             textColor: Colors.white,
//             fontSize: 16.0,
//           );
//
//           /// 步骤 1：调用接口设置 UI
//           jverify.setCustomAuthorizationView(false, uiConfig,
//               landscapeConfig: uiConfig, widgets: widgetList);
//
//           /// 步骤 2：调用一键登录接口
//
//           /// 方式一：使用同步接口 （如果想使用异步接口，则忽略此步骤，看方式二）
//           /// 先，添加 loginAuthSyncApi 接口回调的监听
//
//           Fluttertoast.showToast(
//             msg: '7',
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 1,
//             backgroundColor: Colors.grey[700],
//             textColor: Colors.white,
//             fontSize: 16.0,
//           );
//
//           jverify.addLoginAuthCallBackListener((event) async {
//             Fluttertoast.showToast(
//               msg: '從授權頁回來',
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.CENTER,
//               timeInSecForIosWeb: 1,
//               backgroundColor: Colors.grey[700],
//               textColor: Colors.white,
//               fontSize: 16.0,
//             );
//             String token = event.message.toString();
//
//             Fluttertoast.showToast(
//               msg: '授權：' + token,
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.CENTER,
//               timeInSecForIosWeb: 1,
//               backgroundColor: Colors.grey[700],
//               textColor: Colors.white,
//               fontSize: 16.0,
//             );
//             await writeTextToFile(token);
//
//             /// 再，执行同步的一键登录接口
//             jverify.loginAuthSyncApi(autoDismiss: true);
//           });
//         }
//       } catch (e) {
//         final error = ErrorLogReq(log: "JIGUANGMobAuth = " + e.toString());
//         ref.read(commApiProvider).sendErrorMsgLog(error);
//       }
//     });
//   }
//
//   //獲取號碼認證token
//   static void getToken() {
//     Jverify jverify = Jverify();
//     jverify.checkVerifyEnable().then((map) {
//       if (map["result"]) {
//         jverify.getToken().then((map) async {
//           String toastContent = map["code"].toString();
//           String token = map["message"].toString() ?? "";
//           if (map["code"] == 6000) {
//             int code = map["code"];
//             String _token = map["message"];
//             String operator = map["operator"];
//             print("[$code] message = $_token, operator = $operator");
//           }
//           await writeTextToFile(token);
//
//           Fluttertoast.showToast(
//             msg: toastContent,
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 1,
//             backgroundColor: Colors.grey[700],
//             textColor: Colors.white,
//             fontSize: 16.0,
//           );
//           Fluttertoast.showToast(
//             msg: "token: " + token,
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 1,
//             backgroundColor: Colors.grey[700],
//             textColor: Colors.white,
//             fontSize: 16.0,
//           );
//
//           //後端登入接口
//           // login(_token);
//         });
//       } else {
//         print("[2016],msg = 当前网络环境不支持认证");
//       }
//     });
//   }
//
//   static Future<String> get _localPath async {
//     final directory = await getApplicationSupportDirectory();
//     return directory.path;
//   }
//
//   static Future<File> get _localFile async {
//     final String fileName = 'token.txt';
//     final path = await _localPath;
//     return File('$path/$fileName');
//   }
//
//   static Future<File> writeTextToFile(String text) async {
//     final file = await _localFile;
//     return file.writeAsString(text);
//   }
//
//   //登入
//   static Future<void> login(String _token, WidgetRef ref,
//       {required Function(String) onConnectSuccess,
//         required Function(String) onConnectFail,
//         required Function() onConnectRegister}) async {
//     final String envStr = await AppConfig.getEnvStr();
//     MemberLoginReq req = MemberLoginReq.create(
//         env: envStr, //環境
//         phoneToken: _token, //一鍵登入Token
//         deviceModel: await AppConfig.getDevice(), //设备型号
//         currentVersion: AppConfig.appVersion, //当前版本号
//         systemVersion: AppConfig.buildNumber,
//         express: false,
//         type: 1,
//         tdata: '',
//         phoneNumber: '',
//         merchant: await AppConfig.getMerChant()
//     );
//     ref.read(authenticationProvider).loginAndConnectWs(
//         req: req,
//         onConnectSuccess: (succMsg) async {
//           /// 登入成功，只有登入頁登入需要多存這兩個參數
//           await ref
//               .read(userUtilProvider.notifier)
//               .setDataToPrefs(loginData: req.data, phoneNumber: '');
//           onConnectSuccess(succMsg);
//         },
//         onConnectFail: (errMsg) {
//           if (errMsg == ResponseCode.CODE_ACCOUNT_NOT_FOUND) {
//             onConnectRegister();
//           } else {
//             onConnectFail(errMsg ?? '');
//           }
//         });
//   }
//
//   //假登入、驗證碼登入
//   static Future<void> loginInWithSMSOrPassword(BuildContext context,
//       String phoneNumber, String verificationCode, WidgetRef ref, bool express,
//       {required Function(String) onConnectSuccess,
//         required Function(String) onConnectFail,
//         required Function() onConnectRegister}) async {
//     FcPrefs.setVerificationCode(verificationCode);
//     ref
//         .read(userUtilProvider.notifier)
//         .setDataToPrefs(phoneNumber: phoneNumber);
//     final String envStr = await AppConfig.getEnvStr();
//     MemberLoginReq req = MemberLoginReq.create(
//         env: envStr, //環境
//         phoneNumber: phoneNumber, //手機號
//         phoneToken: verificationCode, //一鍵登入Token
//         deviceModel: await AppConfig.getDevice(), //设备型号
//         currentVersion: AppConfig.appVersion, //当前版本号
//         systemVersion: AppConfig.buildNumber,
//         express: express,
//         type: 2,
//         tdata: '',
//         merchant: await AppConfig.getMerChant()
//     );
//
//     ref.read(authenticationProvider).loginAndConnectWs(
//         req: req,
//         onConnectSuccess: (succMsg) async {
//           /// 登入成功，只有登入頁登入需要多存這兩個參數
//           await ref
//               .read(userUtilProvider.notifier)
//               .setDataToPrefs(loginData: req.data, phoneNumber: phoneNumber);
//           onConnectSuccess(succMsg);
//         },
//         onConnectFail: (errMsg) {
//           if (errMsg == ResponseCode.CODE_ACCOUNT_NOT_FOUND) {
//             onConnectRegister();
//           } else {
//             onConnectFail(errMsg ?? '');
//           }
//         });
//   }
//
//   /// 获取短信验证码
//   static Future<void> getSMSCode(
//       String phoneNumber, WidgetRef ref, BuildContext context,
//       {required Function() onConnectFail}) async {
//     final reqBody = SendSmsReq.create(phonenumber: phoneNumber);
//     await ref.read(commApiProvider).sendSms(reqBody,
//         onConnectSuccess: (succMsg) {}, onConnectFail: (errMsg) {
//           BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
//           onConnectFail();
//         });
//   }
//
//   /// 極光一鍵登入sdk初始化
//   static void initJverifySDK() {
//     Jverify jverify = Jverify();
//     jverify.isInitSuccess().then((map) {
//       if (map["result"]) {
//         print("極光SDK 初始化成功");
//       } else {
//         print("極光SDK 初始化失敗");
//       }
//     });
//   }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   static Future<void> initPlatformState() async {
//     // Jverify jverify =  Jverify();
//     const String jverifyAppKey = "22abe8a9db7e16b7be863a37";
//     // 初始化 SDK 之前添加監聽
//     jVerify.addSDKSetupCallBackListener((JVSDKSetupEvent event) {
//       print("receive sdk setup call back event :${event.toMap()}");
//     });
//     jVerify.setDebugMode(true); // 打开调试模式
//     jVerify.setup(
//         appKey: jverifyAppKey, //"你自己应用的 AppKey",
//         channel: "devloper-default"); // 初始化sdk,  appKey 和 channel 只对ios设置有效
//     /// 授权页面点击时间监听
//     jVerify.addAuthPageEventListener((JVAuthPageEvent event) {
//       print("receive auth page event :${event.toMap()}");
//     });
//   }
//
//   static void test123(String text) {
//     Fluttertoast.showToast(
//       msg: text,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.CENTER,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.grey[700],
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//   }
// }
