
import 'package:json_annotation/json_annotation.dart';

part 'ws_notification_search_online_status_res.g.dart';

@JsonSerializable()
class WsNotificationSearchOnlineStatusRes {
  WsNotificationSearchOnlineStatusRes({
    this.list,
  });

  @JsonKey(name: 'list')
  final List<SearchOnlineStatusInfo>? list;

  factory WsNotificationSearchOnlineStatusRes.fromJson(Map<String, dynamic> json) =>
      _$WsNotificationSearchOnlineStatusResFromJson(json);

  Map<String, dynamic> toJson() => _$WsNotificationSearchOnlineStatusResToJson(this);
}

class SearchOnlineStatusInfo {
  SearchOnlineStatusInfo({
    this.roomId,
    this.gender,
  });

  @JsonKey(name: 'roomId')
  final num? roomId;

  @JsonKey(name: 'gender')
  final num? gender;

  factory SearchOnlineStatusInfo.fromJson(Map<String, dynamic> json) =>
      _$SearchOnlineStatusInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SearchOnlineStatusInfoToJson(this);
}
