// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_login_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberLoginRes _$MemberLoginMapFromJson(Map<String, dynamic> json) =>
    MemberLoginRes(
      userId: json['userId'] != null ? json['userId'] as int : 0,
      nickname: json['nickname'] as String? ?? "",
      tId: json['tId'] as String? ?? "",
      userName: json['userName'] as String?
    );

Map<String, dynamic> _$MemberLoginResToJson(MemberLoginRes instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'nickname': instance.nickname,
      'tId': instance.tId,
      'userName': instance.userName,
    };
