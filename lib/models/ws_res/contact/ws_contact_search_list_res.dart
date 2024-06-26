import 'package:json_annotation/json_annotation.dart';

part 'ws_contact_search_list_res.g.dart';

@JsonSerializable()
class WsContactSearchListRes {
  WsContactSearchListRes({
    this.pageNumber,
    this.totalPages,
    this.fullListSize,
    this.pageSize,
    this.count,
    this.list,
  });

  factory WsContactSearchListRes.create({
    num? pageNumber,
    num? totalPages,
    num? fullListSize,
    num? pageSize,
    num? count,
    List<ContactListInfo>? list
}) {
    return WsContactSearchListRes(
      pageNumber: pageNumber,
      totalPages: totalPages,
      fullListSize: fullListSize,
      pageSize: pageSize,
      count: count,
      list: list,
    );
  }

  /// 當前頁數
  @JsonKey(name: 'pageNumber')
  num? pageNumber;

  /// 總頁數
  @JsonKey(name: 'totalPages')
  num? totalPages;

  /// 總筆數
  @JsonKey(name: 'fullListSize')
  num? fullListSize;

  /// 每頁筆數
  @JsonKey(name: 'pageSize')
  num? pageSize;

  /// 好友人數
  @JsonKey(name: 'count')
  num? count;

  /// list
  @JsonKey(name: 'list')
  List<ContactListInfo>? list;

  factory WsContactSearchListRes.fromJson(Map<String, dynamic> json) =>
      _$WsContactSearchListResFromJson(json);
  Map<String, dynamic> toJson() => _$WsContactSearchListResToJson(this);
}

class ContactListInfo {
  ContactListInfo({
    this.avatarPath,
    this.nickName,
    this.userName,
    this.regTime,
    this.age,
    this.realPersonAuth,
    this.selfIntroduction,
    this.hometown,
    this.height,
    this.weight,
    this.occupation,
    this.gender,
    this.realNameAuth,
  });

  factory ContactListInfo.create({
    String? avatarPath,
    String? nickName,
    String? userName,
    num? regTime,
    num? age,
    num? realPersonAuth,
    String? selfIntroduction,
    String? hometown,
    num? height,
    num? weight,
    String? occupation,
    num? gender,
    num? realNameAuth
  }) {
    return ContactListInfo(
      avatarPath: avatarPath,
      nickName: nickName,
      userName: userName,
      regTime: regTime,
      age: age,
      realPersonAuth: realPersonAuth,
      selfIntroduction: selfIntroduction,
      hometown: hometown,
      height: height,
      weight: weight,
      occupation: occupation,
      gender: gender,
      realNameAuth: realNameAuth,
    );
  }

  /// 頭像路徑
  @JsonKey(name: 'avatarPath')
  String? avatarPath;

  /// 暱稱
  @JsonKey(name: 'nickName')
  String? nickName;

  /// 用戶id
  @JsonKey(name: 'userName')
  String? userName;

  /// 註冊時間
  @JsonKey(name: 'regTime')
  num? regTime;

  /// 年齡
  @JsonKey(name: 'age')
  num? age;

  /// 真人认证
  @JsonKey(name: 'realPersonAuth')
  num? realPersonAuth;

  /// 自我介绍
  @JsonKey(name: 'selfIntroduction')
  String? selfIntroduction;

  @JsonKey(name: 'hometown')
  String? hometown;

  @JsonKey(name: 'height')
  num? height;

  @JsonKey(name: 'weight')
  num? weight;

  @JsonKey(name: 'occupation')
  String? occupation;

  @JsonKey(name: 'gender')
  num? gender;

  @JsonKey(name: 'realNameAuth')
  num? realNameAuth;

  factory ContactListInfo.fromJson(Map<String, dynamic> json) =>
      _$ContactListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ContactListInfoToJson(this);
}
