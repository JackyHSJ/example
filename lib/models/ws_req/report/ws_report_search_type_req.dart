import 'package:json_annotation/json_annotation.dart';

part 'ws_report_search_type_req.g.dart';

@JsonSerializable()
class WsReportSearchTypeReq {
  WsReportSearchTypeReq({
    this.type,
  });

  factory WsReportSearchTypeReq.create({
    String? type,
}) {
    return WsReportSearchTypeReq(type: type);
  }

  /// 舉報類型 0:全部 1:用戶 2:動態
  @JsonKey(name: 'type')
  String? type;


  factory WsReportSearchTypeReq.fromJson(Map<String, dynamic> json) =>
      _$WsReportSearchTypeReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsReportSearchTypeReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
