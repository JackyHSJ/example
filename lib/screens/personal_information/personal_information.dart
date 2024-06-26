import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/models/req/member_login_req.dart';
import 'package:frechat/models/req/member_register_req.dart';
import 'package:frechat/models/res/member_register_res.dart';
import 'package:frechat/models/ws_req/account/ws_account_get_rtm_token_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_rtm_token_res.dart';
import 'package:frechat/screens/home/home.dart';
import 'package:frechat/screens/launch/launch.dart';
import 'package:frechat/screens/personal_information/personal_information_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/ntesdun/ntesdun_mob_auth.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/image_picker_util.dart';
import 'package:frechat/system/util/permission_util.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/loading_dialog/loading_widget.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/buttons/gradient_button.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/rounded_textfield.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:device_info_plus/device_info_plus.dart';


class PersonalInformation extends ConsumerStatefulWidget {
  const PersonalInformation({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends ConsumerState<PersonalInformation> {
  late PersonalInformationViewModel viewModel;
  final TextEditingController _nickNameController = TextEditingController();
  final FocusNode _nickNameInputFocus = FocusNode();
  final TextEditingController _invitationCodeController = TextEditingController();
  final FocusNode _invitationCodeInputFocus = FocusNode();

  int selectGender = 0; // 0：未選 1：女生 2：男生
  String initData = '请输入您的年龄';
  List<String> data = [];
  File? _selectedImage;
  bool isClickPicker = false;
  String? loginData;
  bool confirmNoInvitationCode = false;
  // bool isChooseHaveInventNumber = false;
  // bool isChooseDoNotHaveInventNumber = false;
  bool isFinish = false;
  List<String> defaultNickNameAdjTexts = []; //资料库昵称形容词
  List<String> defaultNickNameNounTexts = []; //资料库昵称名词
  String defaultNickName = ''; //资料库昵称名词
  Random random = Random();
  late AppTheme theme;
  late AppColorTheme appColorTheme;
  late AppTextTheme appTextTheme;
  late AppLinearGradientTheme appLinearGradientTheme;
  late AppImageTheme appImageTheme;
  late AppBoxDecorationTheme appBoxDecorationTheme;

  PickerStyle _getPickerStyle(){
    return PickerStyle(
      backgroundColor: appColorTheme.pickerDialogBackgroundColor,
      title: Container(color: appColorTheme.pickerDialogBackgroundColor),
      textColor: appColorTheme.pickerDialogIconColor,
      commitButton: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 12, right: 22),
          color:  appColorTheme.pickerDialogBackgroundColor,
          child: Text('确定',style:appTextTheme.pickerDialogConfirmButtonTextStyle,)),
      cancelButton: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 12, right: 22),
        color: appColorTheme.pickerDialogBackgroundColor,
        child: Text('取消',style: appTextTheme.pickerDialogCancelButtonTextStyle,),
      ),
    );

  }

  @override
  void initState() {
    super.initState();
    viewModel = PersonalInformationViewModel(ref: ref);
    for (int i = 18; i <= 60; i++) {
      data.add("$i岁");
    }
    _nickNameInputFocus.addListener(() => _onTextFieldFocusChange(_nickNameInputFocus));
    _invitationCodeInputFocus.addListener(() => _onTextFieldFocusChange(_invitationCodeInputFocus));
    getDeviceModel();
    _loadInviteCode();
    getDefaultName();
  }
  @override
  void dispose() {
    _nickNameController.dispose();
    _invitationCodeController.dispose();
    _nickNameInputFocus.dispose();
    _invitationCodeInputFocus.dispose();
    super.dispose();
  }

  Future<void> getDefaultName() async {
    defaultNickNameAdjTexts = const LineSplitter().convert(await rootBundle.loadString('assets/txt/nickname_adj.txt'));
    defaultNickNameNounTexts = const LineSplitter().convert(await rootBundle.loadString('assets/txt/nickname_noun.txt'));
    defaultNickName =defaultNickNameAdjTexts[random.nextInt(200)]+defaultNickNameNounTexts[random.nextInt(100)];
    _nickNameController.text = defaultNickName;
  }

  //取得設備型號
  static void getDeviceModel() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String _deviceModel;
    if (Platform.isAndroid) {
      //取得Android設備信息
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _deviceModel = androidInfo.model;
    } else {
      //取得Ios設備信息
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      _deviceModel = iosInfo.model;
    }
    FcPrefs.setDevice(_deviceModel);
    FcPrefs.setBeautyStatus(true);
  }

  _loadInviteCode() async {
    final isDeepLinkMode = ref.read(userUtilProvider.notifier).isDeepLinkMode;
    if(isDeepLinkMode) {
      final String inviteCode = ref.read(userUtilProvider).inviteCode ?? '';
      _invitationCodeController.text = inviteCode;
      // isChooseHaveInventNumber = true;
      return ;
    }
    setState(() {});
  }

  void _onTextFieldFocusChange(FocusNode focusNode) {
    if (!focusNode.hasFocus) {
      // 第一个文本框失去焦点的逻辑处理
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appColorTheme = theme.getAppColorTheme;
    appImageTheme = theme.getAppImageTheme;
    appTextTheme = theme.getAppTextTheme;
    appLinearGradientTheme = theme.getAppLinearGradientTheme;
    appBoxDecorationTheme = theme.getAppBoxDecorationTheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "完善讯息",
          style: appTextTheme.appbarTextStyle,
        ),
        backgroundColor: appColorTheme.appBarBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: ImgUtil.buildFromImgPath(appImageTheme.iconBack, size: 24.w),
          onPressed: () => BaseViewModel.popPage(context),
        ),
      ),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(appImageTheme.phoneLoginBg),
                  fit: BoxFit.cover,
                )),
            child: SingleChildScrollView(
              child: IntrinsicHeight(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                    MediaQuery.of(context).size.height - kToolbarHeight - MediaQueryData.fromView(window).padding.top,
                  ),
                  child: Column(
                    children: [
                      avatarWidget(),
                      nickNameTextField(),
                      agePicker(),
                      genderLabel(),
                      genderChooseButton(),
                      invitationCodeTextFieldWidget(),
                      Expanded(child: Container()),
                      startButton(
                          onConnectSuccess: (succMsg) async {
                            /// 註冊完成, 載入資料
                            await ref.read(authenticationProvider).preload(context);

                            _initZego();
                          },
                          onConnectFail: (errMsg) => BaseViewModel.pushAndRemoveUntil(context, GlobalData.launch ??  const Launch()))
                    ],
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }

  _initZego() async {
    if (mounted) {
      /// get userName nickName
      final userName = ref.read(userInfoProvider).userName ?? '';
      final checkNickName = ref.read(userInfoProvider).nickName ?? '';
      final String nickName = (checkNickName == '') ? userName : checkNickName;

      /// get rtc token to Login Zego
      final WsAccountGetRTMTokenReq reqBody = WsAccountGetRTMTokenReq.create();
      String? resultCodeCheck;
      final WsAccountGetRTMTokenRes res = await ref.read(accountWsProvider).wsAccountGetRTMToken(
          reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));
      if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
        ref.read(userUtilProvider.notifier).setDataToPrefs(rtcToken: res.rtcToken);
        await ref.read(zegoLoginProvider).init(userName: userName, nickName: nickName, token: res.rtcToken);
        Loading.hide(context);
        BaseViewModel.pushAndRemoveUntil(context, const Home(showAdvertise: true,));
      }
    }
  }

  //開啟相簿
  void openGalleryAndCrop() async {
    //防止連續登入問題 (裁圖/照相功能會造成斷線)
    if (ref.read(commApiProvider).isLegalForNextLogin()) {
      XFile? xFile = await ImagePickerUtil.selectImage(isLoginState: false);
      CroppedFile? croppedFile = await ImagePickerUtil.cropImage(xFile, isLoginState: false);
      if (croppedFile != null) {
        setState(() {
          _selectedImage = File(croppedFile.path);
        });
        checkButton();
      }
    } else {
      await CheckDialog.show(context, titleText: '操作过于频繁', messageText: '请稍候 5 秒', confirmButtonText: '确认', appTheme: theme);
    }
  }

  // 大頭貼
  Widget avatarWidget() {


    Widget image = AvatarUtil.localAvatar(appImageTheme.registerAvatarDefault, size: 120.w, radius: 12);
    if(_selectedImage != null){
      image = AvatarUtil.fileAvatar(_selectedImage!, size: 120.w, radius: 12);
    }else if(selectGender == 1){
      image = AvatarUtil.localAvatar(appImageTheme.defaultFemaleAvatar, size: 120.w, radius: 12);
    }else if(selectGender == 2){
      image = AvatarUtil.localAvatar(appImageTheme.defaultMaleAvatar, size: 120.w, radius: 12);
    }else{
      image = AvatarUtil.localAvatar(appImageTheme.registerAvatarDefault, size: 120.w, radius: 12);
    }

    return Padding(
        padding: EdgeInsets.symmetric(vertical: 28.h,),
        child: GestureDetector(
          onTap: openGalleryAndCrop,
          child: image,
        )
    );
  }

  //暱稱輸入框
  Widget nickNameTextField() {
    return RoundedTextField(
      textEditingController: _nickNameController,
      borderColor: appBoxDecorationTheme.registerAgeBoxDecoration.border!.top.color,
      focusNode: _nickNameInputFocus,
      focusBorderColor: appColorTheme.textFieldFocusingColor,
      textInputType: TextInputType.text,
      prefixIcon: IconButton(
        onPressed: () {},
        icon: ImgUtil.buildFromImgPath('assets/register/icon_nickname.png', size: 24.w),
      ),
      maxLength: 10,
      suffixIcon: randomNickNameBt(),
      hint: "起个好听的昵称",
      hintTextStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: AppColors.mainGrey,
      ),
      onChange: (text) {
        checkButton();
      },
    );
  }

  Widget randomNickNameBt(){
    return InkWell(
        child: Container(
          width: 64.w,
          height: 26.h,
          alignment: const Alignment(0,0),
          margin: EdgeInsets.only(top: 8.h, bottom: 8.h,right: 8.w),
          decoration: const BoxDecoration(
            color: AppColors.textFormBlack,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Text('随机产生',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
                color: AppColors.navigationBarWhite
            ),),
        ),
        onTap: (){
          defaultNickName =defaultNickNameAdjTexts[random.nextInt(200)]+defaultNickNameNounTexts[random.nextInt(100)];
          _nickNameController.text = defaultNickName;
          setState(() {});
        }
    );
  }

  //年齡選擇器
  Widget agePicker() {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(left: 24, top: 20, right: 24),
        decoration: appBoxDecorationTheme.registerAgeBoxDecoration,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 12, top: 10, bottom: 10),
              child: ImgUtil.buildFromImgPath('assets/register/icon_age.png', size: 24.w),
            ),
            Container(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                initData,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: isClickPicker ? AppColors.textFormBlack : AppColors.mainGrey,
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Pickers.showSinglePicker(
          context,
          data: data,
          selectData: initData,
          pickerStyle: _getPickerStyle(),
          onConfirm: (p, position) {
            initData = p;
            isClickPicker = true;
            checkButton();
            setState(() {});
          },
        );
      },
    );
  }

  //性別label
  Widget genderLabel() {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 26),
      child: const Row(
        children: [
          Text(
            "选择您的性别",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(66, 70, 72, 1),
            ),
          ),
          Text(
            "（确认后不可修改确认）",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.mainGrey,
            ),
          ),
        ],
      ),
    );
  }

  //性別按鈕選擇
  Widget genderChooseButton() {
    return Container(
      padding: const EdgeInsets.only(left: 24, top: 12, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: GradientButton(
                radius: 24,
                height: 48,
                text: '我是男生',
                gradientColorBegin:
                (selectGender == 2) ? appLinearGradientTheme.buttonChooseMale.colors[0] : appLinearGradientTheme.buttonUnChooseGender.colors[0],
                gradientColorEnd:
                (selectGender == 2) ? appLinearGradientTheme.buttonChooseMale.colors[1] : appLinearGradientTheme.buttonUnChooseGender.colors[0],
                alignmentBegin: Alignment.bottomLeft,
                alignmentEnd: Alignment.topRight,
                textStyle: TextStyle(
                  color: (selectGender == 2) ? appColorTheme.registerGenderSelectTextColor : appColorTheme.registerGenderUnSelectTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  decoration: TextDecoration.none,
                ),
                widget: Container(
                  padding: const EdgeInsets.only(right: 8),
                  child: (selectGender == 2)
                      ? ImgUtil.buildFromImgPath(appImageTheme.iconMaleSelected, size: 24.w)
                      : ImgUtil.buildFromImgPath(appImageTheme.iconMaleUnSelect, size: 24.w),
                ),
                onPressed: () {
                  selectGender = 2;
                  checkButton();
                },
              )),
          const SizedBox(width: 15),
          Expanded(
              child: GradientButton(
                radius: 24,
                height: 48,
                text: '我是女生',
                gradientColorBegin:
                (selectGender == 1) ? appLinearGradientTheme.buttonChooseFemale.colors[0] : appLinearGradientTheme.buttonUnChooseGender.colors[0],
                gradientColorEnd:
                (selectGender == 1) ? appLinearGradientTheme.buttonChooseFemale.colors[1]  : appLinearGradientTheme.buttonUnChooseGender.colors[1],
                alignmentBegin: Alignment.topCenter,
                alignmentEnd: Alignment.bottomCenter,
                textStyle: TextStyle(
                  color: (selectGender == 1) ? appColorTheme.registerGenderSelectTextColor : appColorTheme.registerGenderUnSelectTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  decoration: TextDecoration.none,
                ),
                widget: Container(
                  padding: const EdgeInsets.only(right: 8),
                  child: (selectGender == 1)
                      ? ImgUtil.buildFromImgPath(appImageTheme.iconFemaleSelected, size: 24.w)
                      : ImgUtil.buildFromImgPath(appImageTheme.iconFemaleUnSelect, size: 24.w),
                ),
                onPressed: () {
                  selectGender = 1;
                  checkButton();
                },
              ))
        ],
      ),
    );
  }

  //邀请碼
  Widget invitationCodeTextFieldWidget() {
    var isDeepLinkMode = ref.read(userUtilProvider.notifier).isDeepLinkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
      child: RoundedTextField(
        margin: const EdgeInsets.all(0),
        enableTextField: !isDeepLinkMode,
        textEditingController: _invitationCodeController,
        focusNode: _invitationCodeInputFocus,
        focusBorderColor: appColorTheme.textFieldFocusingColor,
        textInputType: TextInputType.text,
        hint: "请输入邀请码（选填）",
        hintTextStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: AppColors.mainGrey,
        ),
        onChange: (text) {
          checkButton();
        },
      ),
    );
  }

  //邀请碼選項按鈕
  Widget isHaveInventNumberButton(String text, bool chooseStatus) {
    return Container(
      height: 48,
      alignment: const Alignment(0, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: (chooseStatus)
              ? [AppColors.mainPink, AppColors.mainPetalPink]
              : [AppColors.mainSnowWhite, AppColors.mainSnowWhite],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 14,
            color: (chooseStatus) ? Colors.white : AppColors.textFormBlack,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  //開啟緣分
  Widget startButton({required Function(String) onConnectSuccess, required Function(String) onConnectFail}) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 54),
      child: GradientButton(
        radius: 24,
        height: 48,
        text: '开启缘分',
        gradientColorBegin: (isFinish) ? appLinearGradientTheme.buttonPrimaryColor.colors[0] : appLinearGradientTheme.buttonDisableColor.colors[1],
        gradientColorEnd: (isFinish) ?appLinearGradientTheme.buttonPrimaryColor.colors[1] : appLinearGradientTheme.buttonDisableColor.colors[1],
        alignmentBegin: Alignment.topCenter,
        alignmentEnd: Alignment.bottomCenter,
        textStyle:(isFinish) ? appTextTheme.buttonPrimaryTextStyle : appTextTheme.buttonDisableTextStyle,
        // textStyle: TextStyle(
        //   color: (isFinish) ? Color.fromRGBO(255, 255, 255, 1) : AppColors.mainDark,
        //   fontWeight: FontWeight.w500,
        //   fontSize: 14,
        //   decoration: TextDecoration.none,
        // ),
        onPressed: () async {
          if (!isFinish) {
            Fluttertoast.showToast(
              msg: "未完善信息",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey[700],
              textColor: Colors.white,
              fontSize: 16.0,
            );
          } else {
            Loading.show(context, "注册中...");
            // if (isChooseDoNotHaveInventNumber) {
            //   _invitationCodeController.clear();
            // }
            final regisRes = await register(_nickNameController.text, _invitationCodeController.text,
                selectGender.toString(), initData.substring(0, initData.length - 1), ref, context, _selectedImage);
            if (regisRes != null) {
              await ref.read(userUtilProvider.notifier).setDataToPrefs(
                commToken: regisRes.tId,
                loginData: loginData,
                userName: regisRes.userName,
                nickName: regisRes.nickName,
                userId: regisRes.userId,
              );
              if (mounted) {
                await ref.read(webSocketUtilProvider).connectWebSocket(
                  onConnectSuccess: (succMsg) => onConnectSuccess(succMsg),
                  onConnectFail: (errMsg) => onConnectFail(errMsg),
                );
              }
            } else {
              //重新註冊流程
              if (mounted) {
                Loading.hide(context);
                Navigator.of(context).pop();
              }
            }
          }
        },
      ),
    );
  }

  //檢查資訊是否有填
  checkButton() {
    if (selectGender == 0) {
      setState(() {
        isFinish = false;
      });
      return;
    }
    ///需求改变女生不用上传头像
    // if (_selectedImage == null && selectGender == 1) {
    //   setState(() {
    //     isFinish = false;
    //   });
    //   return;
    // }
    if (_nickNameController.text == "") {
      setState(() {
        isFinish = false;
      });
      return;
    }
    if (initData == "请输入您的年龄") {
      setState(() {
        isFinish = false;
      });
      return;
    }
    setState(() {
      isFinish = true;
    });
  }

  Future<XFile?> convertFileToXFile(File file) async {
    if (file.existsSync()) {
      // 获取文件的路径
      String filePath = file.path;

      // 使用XFile构造函数将File对象转换为XFile对象
      XFile xFile = XFile(filePath);

      return xFile;
    } else {
      print('文件不存在');
      return null;
    }
  }

  Future<MemberRegisterRes?> register(String nickName, String invitationCode, String gender, String age, WidgetRef ref,
      BuildContext context, File? selectedImage) async {
    String resultCode = '';
    final String envStr = await AppConfig.getEnvStr();
    final String appId = AppConfig.getBundleId();
    final String loginType =await FcPrefs.getLoginType();
    String token1 = '';
    if(loginType =='2'){
      token1 = NTESDUNMobAuth.tokenList[0];
    }
    MemberRegisterReq req = MemberRegisterReq.create(
        env: envStr, //環境
        phoneNumber: await FcPrefs.getPhoneNumber(), //手機號
        phoneToken: await FcPrefs.getVerificationCode(), //一鍵登入Token
        nickName: nickName, //暱稱
        firstRegPackage: appId, //首次注册包
        code: invitationCode.toUpperCase(), //邀请码
        gender: (int.parse(gender) - 1).toString(), //性别 (0/1)
        age: age, //年龄
        deviceModel: await AppConfig.getDevice(), //设备型号
        currentVersion: AppConfig.appVersion, //当前版本号
        systemVersion: AppConfig.buildNumber, //系统版本
        avatarImg: selectedImage,
        token1: token1,
        merchant: await AppConfig.getMerChant()
    );

    //使用 memberRegisterResProvider 來做註冊動作，這會存下這個 MemberRegisterRes state 於 provider 內，供 Home 判斷是否首次註冊完成使用。
    MemberRegisterRes? memberRegisterRes = await ref.read(memberRegisterResProvider.notifier).memberRegister(ref, req,
        onConnectSuccess: (succMsg) => resultCode = succMsg,
        onConnectFail: (errMsg) => resultCode = errMsg
    );
    if (resultCode == ResponseCode.CODE_SUCCESS) {
      if(selectedImage != null){
        XFile? xFile = await convertFileToXFile(selectedImage);
        ImagePickerUtil.saveImageToLocal(xFile: xFile!, type: SaveImagType.avatar,fileName: 'avatar_${memberRegisterRes?.userName}.png');
      }
      final String envStr = await AppConfig.getEnvStr();
      loginData = MemberLoginReq.create(
          env: envStr, //環境
          phoneNumber: await FcPrefs.getPhoneNumber(), //手機號
          phoneToken: await FcPrefs.getVerificationCode(), //一鍵登入Token
          deviceModel: await AppConfig.getDevice(), //设备型号
          currentVersion: AppConfig.appVersion, //当前版本号
          systemVersion: AppConfig.buildNumber,
          type: 2,
          tdata: '',
          tokenType: loginType,
          merchant: await AppConfig.getMerChant(),
          version: AppConfig.appVersion
      ).data;
      await FcPrefs.setLoginType('');
      return memberRegisterRes;
    } else if(resultCode == ResponseCode.CODE_CONTENT_VIOLATES_REGULATIONS) {
      if (mounted) Loading.hide(context);
      BaseViewModel.showToast(context, ResponseCode.map[resultCode]!);
    } else {
      if (mounted) Loading.hide(context);
      if(resultCode == ResponseCode.CODE_REGISTER_REQUEST_TIMEOUT){
        ///註冊超時
        if (context.mounted) Navigator.pop(context);
      }
      if (mounted) {
        String errorMessage = ResponseCode.getLocalizedDisplayStr(resultCode);
        await CheckDialog.show(context,
            appTheme: theme,
            titleText: '注册错误', messageText: '$errorMessage\n请重新注册', confirmButtonText: '确定');
      }
      return null;
    }
  }
}

