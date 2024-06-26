
class AnalyticsLogin {
  AnalyticsLogin({
    this.nickname,
    this.tId,
    this.userName
  });

  final String? nickname;
  final String? tId;
  final String? userName;

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'tId': tId,
      'userName': userName,
    };
  }

  factory AnalyticsLogin.fromJson(Map<String, dynamic> map) {
    return AnalyticsLogin(
      nickname: map['nickname'] as String?,
      tId: map['tId'] as String?,
      userName: map['userName'] as String?,
    );
  }
}