// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_check_in_search_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsCheckInSearchListRes _$WsCheckInSearchListResFromJson(Map<String, dynamic> json) => WsCheckInSearchListRes(
      continuousNum: json['continuousNum'] as num?,
      todayCount: json['todayCount'] as num?,
      list: (json['list'] as List).map((info) => CheckInListInfo.fromJson(info)).toList(),
    );

Map<String, dynamic> _$WsCheckInSearchListResToJson(WsCheckInSearchListRes instance) => <String, dynamic>{
      'list': instance.list,
      'todayCount': instance.todayCount,
      'continuousNum': instance.continuousNum,
    };

CheckInListInfo _$CheckInListInfoFromJson(Map<String, dynamic> json) => CheckInListInfo(
      day: json['day'] as num?,
      giftId: json['giftId'] as num?,
      giftName: json['giftName'] as String?,
      giftUrl: json['giftUrl'] as String?,
      gold: json['gold'] as num?,
      punchInFlag: json['punchInFlag'] as num?,
    );

Map<String, dynamic> _$CheckInListInfoToJson(CheckInListInfo instance) => <String, dynamic>{
      'day': instance.day,
      'giftId': instance.giftId,
      'giftName': instance.giftName,
      'giftUrl': instance.giftUrl,
      'gold': instance.gold,
      'punchInFlag': instance.punchInFlag,
    };
