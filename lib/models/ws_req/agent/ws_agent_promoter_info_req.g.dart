// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_agent_promoter_info_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAgentPromoterInfoReq _$WsAgentPromoterInfoReqFromJson(Map<String, dynamic> json) =>
    WsAgentPromoterInfoReq(
      sort: json['sort'] as String?,
      dir: json['dir'] as String?,
      page: json['page'] as String?,
      size: json['size'] as num?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$WsAgentPromoterInfoReqToJson(WsAgentPromoterInfoReq instance) =>
    <String, dynamic>{
      'sort': instance.sort,
      'dir': instance.dir,
      'page': instance.page,
      'size': instance.size,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'userId': instance.userId,
    };