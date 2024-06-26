
class CommEndpoint{
  //檢查 Server 存活
  static String get keepAliveCheck {
    return '/keepAlive/check';
  }

  //登入
  static String get memberLogin {
    return '/member/login';
  }

  //註冊
  static String get memberRegister {
    return '/member/register';
  }

  //登出
  static String get memberLogout {
    return '/member/logOut';
  }

  // 舉報用戶
  static String get reportUser {
    return '/report/report';
  }

  //檢查 Server 存活
  static String get memberModifyUser {
    return '/member/modifyUser';
  }

  //新增招呼模板
  static String get greetModuleAdd {
    return '/freGreetingModel/add';
  }

  //編輯招呼模板
  static String get greetModuleEdit {
    return '/freGreetingModel/update';
  }

  //上傳真人认证
  static String get uploadRealPersonImg {
    return '/member/realPersonUpload';
  }

  //Error Log
  static String get sendErrorMsgLog {
    return '/jpush/debug';
  }

  //傳送簡訊驗證碼
  static String get sendSms {
    return '/member/sendSms';
  }

  //檢查server
  static String get checkAliveAndNetWorkSpeed {
    return '/keepAlive/check';
  }

  //動態發佈
  static String get addActivityPost {
    return '/feeds/add';
  }

  //檢查App版本
  static String get checkAppVersion {
    return '/appConfig/configs';
  }
}
