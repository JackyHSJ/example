// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_agent_member_list_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAgentMemberListReq _$WsAgentMemberListReqFromJson(Map<String, dynamic> json) =>
    WsAgentMemberListReq(
      sort: json['sort'] as String?,
      dir: json['dir'] as String?,
      page: json['page'] as String?,
      size: json['size'] as num?,
      profit: json['profit'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      userName: json['userName'] as String?,
      userId: json['userId'] as String?,
      mode: json['mode'] as String,
    );

Map<String, dynamic> _$WsAgentMemberListReqToJson(WsAgentMemberListReq instance) =>
    <String, dynamic>{
      'sort': instance.sort,
      'dir': instance.dir,
      'page': instance.page,
      'size': instance.size,
      'profit': instance.profit,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'userName': instance.userName,
      'userId': instance.userId,
      'mode': instance.mode,
    };