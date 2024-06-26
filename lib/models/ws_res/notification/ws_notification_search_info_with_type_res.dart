import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_notification_search_info_with_type_res.g.dart';

@JsonSerializable()
class WsNotificationSearchInfoWithTypeRes {
  WsNotificationSearchInfoWithTypeRes({
    this.roomCount,
    this.roomList,
    this.list,
  });

  /// 總房間數
  @JsonKey(name: 'roomCount')
  final num? roomCount;

  /// 總頁數
  @JsonKey(name: 'roomList')
  final List<dynamic>? roomList;

  /// 房間清單
  @JsonKey(name: 'list')
  final List<SearchListInfo>? list;

  factory WsNotificationSearchInfoWithTypeRes.fromJson(Map<String, dynamic> json) =>
      _$WsNotificationSearchInfoWithTypeResFromJson(json);
  Map<String, dynamic> toJson() => _$WsNotificationSearchInfoWithTypeResToJson(this);
}