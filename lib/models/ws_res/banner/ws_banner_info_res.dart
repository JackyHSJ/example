import 'package:json_annotation/json_annotation.dart';

part 'ws_banner_info_res.g.dart';

@JsonSerializable()
class WsBannerInfoRes {
  WsBannerInfoRes({
    this.list,
});

  @JsonKey(name: 'list')
  List<BannerInfo>? list;

  factory WsBannerInfoRes.fromJson(Map<String, dynamic> json) =>
      _$WsBannerInfoResFromJson(json);
  Map<String, dynamic> toJson() => _$WsBannerInfoResToJson(this);
}

@JsonSerializable()
class BannerInfo {
  BannerInfo({
    this.bannerId,
    this.activityId,
    this.activityBanner,
    this.activityName,
    this.activityLink,
    this.activityType,
    this.locatedPage,
    this.startTime,
    this.endTime,
    this.targetPeople,
    this.status,
    this.greyZoneSex,
    this.greyRegisterTime,
    this.greyRegisterEndTime,
    this.greyRecharge,
    this.fileUploadId,
});
  factory BannerInfo.create({
    num? bannerId,
    String? activityId,
    String? activityBanner,
    String? activityName,
    String? activityLink,
    num? activityType,
    num? locatedPage,
    num? startTime,
    num? endTime,
    num? targetPeople,
    num? status,
    num? greyZoneSex,
    num? greyRegisterTime,
    num? greyRegisterEndTime,
    num? greyRecharge,
    num? fileUploadId,
}) {
    return BannerInfo(
      bannerId: bannerId,
      activityId: activityId,
      activityBanner: activityBanner,
      activityName: activityName,
      activityLink: activityLink,
      activityType: activityType,
      locatedPage: locatedPage,
      startTime: startTime,
      endTime: endTime,
      targetPeople: targetPeople,
      status: status,
      greyZoneSex: greyZoneSex,
      greyRegisterTime: greyRegisterTime,
      greyRegisterEndTime: greyRegisterEndTime,
      greyRecharge: greyRecharge,
      fileUploadId: fileUploadId,
    );
  }

  /// 彈窗 id
  @JsonKey(name: 'bannerId')
  num? bannerId;

  /// 活動id
  @JsonKey(name: 'activityId')
  String? activityId;

  /// 活動BANNER
  @JsonKey(name: 'activityBanner')
  String? activityBanner;

  /// 活動名稱
  @JsonKey(name: 'activityName')
  String? activityName;

  /// 活動連結
  @JsonKey(name: 'activityLink')
  String? activityLink;

  /// 活動類型
  @JsonKey(name: 'activityType')
  num? activityType;

  /// 放置頁面(0:全部 1:首頁 2:充值彈窗 3:消息頁面 4:通話頁面懸浮 5:我的頁面 6:首页悬浮)
  @JsonKey(name: 'locatedPage')
  num? locatedPage;

  /// 開始時間
  @JsonKey(name: 'startTime')
  num? startTime;

  /// 結束時間
  @JsonKey(name: 'endTime')
  num? endTime;

  /// 針對人群(0:全部,1:灰度)
  @JsonKey(name: 'targetPeople')
  num? targetPeople;

  /// 彈窗狀態（0: 進行中, 1: 已結束）
  @JsonKey(name: 'status')
  num? status;

  /// 灰度配置選擇性別(0:全部 1:男性 2:女性)
  @JsonKey(name: 'greyZoneSex')
  num? greyZoneSex;

  /// 灰度配置註冊時間(Start)
  @JsonKey(name: 'greyRegisterTime')
  num? greyRegisterTime;

  /// 灰度配置註冊時間(End)
  @JsonKey(name: 'greyRegisterEndTime')
  num? greyRegisterEndTime;

  /// 灰度配置是否充值(0:不限 1:未充值 2:已充值)
  @JsonKey(name: 'greyRecharge')
  num? greyRecharge;

  /// 關聯file_upload_id
  @JsonKey(name: 'fileUploadId')
  num? fileUploadId;

  factory BannerInfo.fromJson(Map<String, dynamic> json) =>
      _$BannerInfoFromJson(json);
  Map<String, dynamic> toJson() => _$BannerInfoToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}