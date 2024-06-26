// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_member_fate_recommend_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsMemberFateRecommendReq _$WsMemberFateRecommendReqFromJson(Map<String, dynamic> json) =>
    WsMemberFateRecommendReq(
        page: json['page'] as num?,
        topListPage: json['topListPage'] as num?,
        // onlineOnly: json['onlineOnly'] as bool?,
        orderSeq: json['orderSeq'] as num?,
        totalPages: json['totalPages'] as num?

    );

Map<String, dynamic> _$WsMemberFateRecommendReqToJson(WsMemberFateRecommendReq instance) =>
    <String, dynamic>{
      'page': instance.page,
      'topListPage': instance.topListPage,
      // 'onlineOnly': instance.onlineOnly,
      'orderSeq': instance.orderSeq,
      'totalPages': instance.totalPages,
    };
