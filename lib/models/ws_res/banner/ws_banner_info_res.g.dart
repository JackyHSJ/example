// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_banner_info_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsBannerInfoRes _$WsBannerInfoResFromJson(Map<String, dynamic> json) =>
    WsBannerInfoRes(
      list: (json['list'] as List).map((info) => BannerInfo.fromJson(info)).toList()
    );

Map<String, dynamic> _$WsBannerInfoResToJson(WsBannerInfoRes instance) => 
    <String, dynamic>{
      'list': instance.list,
    };

BannerInfo _$BannerInfoFromJson(Map<String, dynamic> json) =>
    BannerInfo(
      bannerId: json['bannerId'] as num?,
      activityId: json['activityId'] as String?,
      activityBanner: json['activityBanner'] as String?,
      activityName: json['activityName'] as String?,
      activityLink: json['activityLink'] as String?,
      activityType: json['activityType'] as num?,
      locatedPage: json['locatedPage'] as num?,
      startTime: json['startTime'] as num?,
      endTime: json['endTime'] as num?,
      targetPeople: json['targetPeople'] as num?,
      status: json['status'] as num?,
      greyZoneSex: json['greyZoneSex'] as num?,
      greyRegisterTime: json['greyRegisterTime'] as num?,
      greyRegisterEndTime: json['greyRegisterEndTime'] as num?,
      greyRecharge: json['greyRecharge'] as num?,
      fileUploadId: json['fileUploadId'] as num?,
    );

Map<String, dynamic> _$BannerInfoToJson(BannerInfo instance) =>
    <String, dynamic>{
      'bannerId': instance.bannerId,
      'activityId': instance.activityId,
      'activityBanner': instance.activityBanner,
      'activityName': instance.activityName,
      'activityLink': instance.activityLink,
      'activityType': instance.activityType,
      'locatedPage': instance.locatedPage,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'targetPeople': instance.targetPeople,
      'status': instance.status,
      'greyZoneSex': instance.greyZoneSex,
      'greyRegisterTime': instance.greyRegisterTime,
      'greyRegisterEndTime': instance.greyRegisterEndTime,
      'greyRecharge': instance.greyRecharge,
      'fileUploadId': instance.fileUploadId,
    };