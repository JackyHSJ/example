import 'package:json_annotation/json_annotation.dart';

part 'ws_visitor_list_res.g.dart';

@JsonSerializable()
class WsVisitorListRes {
  WsVisitorListRes({
    this.list,
    this.fullListSize,
  });

  @JsonKey(name: 'fullListSize')
  num? fullListSize;

  @JsonKey(name: 'list')
  List<VisitorInfo>? list;

  factory WsVisitorListRes.fromJson(Map<String, dynamic> json) =>
      _$WsVisitorListResFromJson(json);
  Map<String, dynamic> toJson() => _$WsVisitorListResToJson(this);
}

@JsonSerializable()
class VisitorInfo {
  VisitorInfo({
    this.gender,
    this.realPersonAuth,
    this.userName,
    this.nickName,
    this.userId,
    this.age,
    this.updateTime,
    this.avatar,
  });

  /// 使用者的性別。0：男性，1：女性，2：其他
  @JsonKey(name: 'gender')
  num? gender;

  /// 真人认证。0：否，1：是
  @JsonKey(name: 'realPersonAuth')
  num? realPersonAuth;

  /// 使用者的唯一用戶名
  @JsonKey(name: 'userName')
  String? userName;

  /// 使用者顯示的暱稱
  @JsonKey(name: 'nick_name')
  String? nickName;

  /// 用户ID
  @JsonKey(name: 'userId')
  num? userId;

  /// 使用者的年齡
  @JsonKey(name: 'age')
  num? age;

  /// 访问時間戳
  @JsonKey(name: 'updateTime')
  num? updateTime;

  /// 使用者头像
  @JsonKey(name: 'avatar')
  String? avatar;

  factory VisitorInfo.fromJson(Map<String, dynamic> json) =>
      _$VisitorListFromJson(json);
  Map<String, dynamic> toJson() => _$VisitorListToJson(this);
}
