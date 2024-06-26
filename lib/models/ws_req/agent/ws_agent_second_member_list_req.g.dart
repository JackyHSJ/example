// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_agent_second_member_list_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAgentSecondMemberListReq _$WsAgentSecondMemberListReqFromJson(Map<String, dynamic> json) =>
    WsAgentSecondMemberListReq(
      sort: json['sort'] as String?,
      dir: json['dir'] as String?,
      page: json['page'] as String?,
      size: json['size'] as num?,
      profit: json['profit'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
    );

Map<String, dynamic> _$WsAgentSecondMemberListReqToJson(WsAgentSecondMemberListReq instance) =>
    <String, dynamic>{
      'sort': instance.sort,
      'dir': instance.dir,
      'page': instance.page,
      'size': instance.size,
      'profit': instance.profit,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'userId': instance.userId,
      'userName': instance.userName,
    };