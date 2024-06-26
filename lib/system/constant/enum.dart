enum CertificationType {
  not,
  done,
  processing,
  fail,
  resend,
  reject,

  using,
  unUse,
}

enum ImgType { urlPath, filePath, none }

enum MesageDialogType { readAllMessage, deleteAllMessage, deleteThisMessage }

enum MessageTabType { message, cohesion, call }

enum GreetType { add, update }

enum InviteFriendType { agent, contact }

enum PersonalAgentMemberUnitType { time, frequency, amount }

enum MateState { init, close, open, loading, error }

enum PersonalFreindType { follow, fans}

enum SaveImagType { avatar, other }

enum PipStatus { init, piping, closeButUsed }

enum AppEnvType { Dev, QA, Production, UAT, Review}

enum ActivityDetialType { Show , Hide}

enum UserCallStatus {
  init, // 使用者正在初始狀態
  calling, // 使用者正在通話ing
  emptyCall, // 假撥通狀態
  outGoingRinging, // 撥出通話正在響鈴
  incomingRinging, // 接收來電正在響鈴
  // ended, // 通話已結束
  // declined, // 通話被拒絕
  // failed, // 通話失敗
  callOnHoldWithWaitingCall, // 通話保持並有電話正在等待中
}

enum AppPaymentStatus {init,paying,dispose,}

enum AgentTagType { normalFriend, agentContact , level2Agent, level2AgentContact, level2FriendContact }

enum AppThemeType { catVersion, original, dogVersion, yueyuan }

/// 是否為好友(
/// "friends": 一級好友成員列表
/// "primaryPromotor": 一級推廣人脈
/// "agent": 二級推廣
/// null: 同時查詢二級規廣跟一級推廣人脈
enum AgentMemberListMode { friends, primaryPromotor, agent , secondAgentContact, secondFriendContact, secondaryAgent}

enum AgentSecondAgentListMode { agent, friend}

///猫版速配按钮
enum CatSpeedDatingType { ai, video, voice }

enum NewUserBehaviorState{
  strike, onlineDuration
}

enum OfflineCallType {
  accept, handout, none
}

enum AppBundleType {
  frechat, yueyuan
}

enum SettingIapType {
  voice, video, message
}

enum PersonalCellType { normal, img, intro, tag, audio, custom }