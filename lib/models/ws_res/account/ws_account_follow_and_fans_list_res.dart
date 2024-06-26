
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_follow_and_fans_list_res.g.dart';

@JsonSerializable()
class WsAccountFollowAndFansListRes {
  WsAccountFollowAndFansListRes({
    this.pageNumber,
    this.totalPages,
    this.fullListSize,
    this.pageSize,
    this.list,
  });

  @JsonKey(name: 'pageNumber')
  final num? pageNumber;

  @JsonKey(name: 'totalPages')
  final num? totalPages;

  @JsonKey(name: 'fullListSize')
  final num? fullListSize;

  @JsonKey(name: 'pageSize')
  final num? pageSize;

  /// 0:文字訊息 1:圖片上傳 2:引言
  @JsonKey(name: 'list')
  final List<AccountListInfo>? list;

  factory WsAccountFollowAndFansListRes.fromJson(Map<String, dynamic> json) =>
      _$WsAccountFollowAndFansListResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountFollowAndFansListResToJson(this);

  WsAccountFollowAndFansListRes copyWith({
    num? pageNumber,
    num? totalPages,
    num? fullListSize,
    num? pageSize,
    List<AccountListInfo>? list,
  }) {
    return WsAccountFollowAndFansListRes(
      pageNumber: pageNumber ?? this.pageNumber,
      totalPages: totalPages ?? this.totalPages,
      fullListSize: fullListSize ?? this.fullListSize,
      pageSize: pageSize ?? this.pageSize,
      list: list ?? this.list,
    );
  }
}

class AccountListInfo {
  AccountListInfo({
    this.occupation,
    this.gender,
    this.nickName,
    this.weight,
    this.height,
    this.id,
    this.age,
    this.location,
    this.selfIntroduction,
    this.roomId,
    this.avatar,
    this.realNameAuth,
    this.realPersonAuth,
    this.userName,
  });

  @JsonKey(name: 'occupation')
  final String? occupation;

  @JsonKey(name: 'gender')
  final num? gender;

  @JsonKey(name: 'nickName')
  final String? nickName;

  @JsonKey(name: 'weight')
  final num? weight;

  @JsonKey(name: 'id')
  final num? id;

  @JsonKey(name: 'age')
  final num? age;

  @JsonKey(name: 'height')
  final num? height;

  @JsonKey(name: 'location')
  final String? location;

  @JsonKey(name: 'selfIntroduction')
  final String? selfIntroduction;

  @JsonKey(name: 'roomId')
  final num? roomId;

  @JsonKey(name: 'avatar')
  final String? avatar;

  @JsonKey(name: 'realPersonAuth')
  final num? realPersonAuth;

  @JsonKey(name: 'realNameAuth')
  final num? realNameAuth;

  @JsonKey(name: 'userName')
  final String? userName;

  factory AccountListInfo.fromJson(Map<String, dynamic> json) =>
      _$AccountListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AccountListInfoToJson(this);
}

