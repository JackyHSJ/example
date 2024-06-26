// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_contact_search_friend_benefit_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsContactSearchFriendBenefitReq _$WsContactSearchFriendBenefitReqFromJson(Map<String, dynamic> json) =>
    WsContactSearchFriendBenefitReq(
      startTime: json['startTime'] as  String?,
      endTime: json['endTime'] as  String?,
      size: json['size'] as  num?,
      page: json['page'] as num?
    );

Map<String, dynamic> _$WsContactSearchFriendBenefitReqToJson(WsContactSearchFriendBenefitReq instance) =>
    <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'size': instance.size,
      'page': instance.page,
    };