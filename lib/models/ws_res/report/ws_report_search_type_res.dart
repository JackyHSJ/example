import 'package:json_annotation/json_annotation.dart';

part 'ws_report_search_type_res.g.dart';

@JsonSerializable()
class WsReportSearchTypeRes {
  WsReportSearchTypeRes({this.list});

  factory WsReportSearchTypeRes.create({
    List<ReportListInfo>? list
}) {
    return WsReportSearchTypeRes(list: list);
  }

  @JsonKey(name: 'list')
  List<ReportListInfo>? list;

  factory WsReportSearchTypeRes.fromJson(Map<String, dynamic> json) =>
      _$WsReportSearchTypeResFromJson(json);
  Map<String, dynamic> toJson() => _$WsReportSearchTypeResToJson(this);
}

class ReportListInfo {
  ReportListInfo({
    this.id,
    this.type,
    this.reason,
    this.seq,
    this.writeTime,
    this.updateTime,
    this.systemUser,
    this.status,
  });

  factory ReportListInfo.create({
    num? id,
    String? type,
    String? reason,
    num? seq,
    num? writeTime,
    num? updateTime,
    String? systemUser,
    num? status,
  }) {
    return ReportListInfo(
        id: id,
        type: type,
        reason: reason,
        seq: seq,
        writeTime: writeTime,
        updateTime: updateTime,
        systemUser: systemUser,
        status: status
    );
  }

  @JsonKey(name: 'id')
  num? id;

  @JsonKey(name: 'type')
  String? type;

  @JsonKey(name: 'reason')
  String? reason;

  @JsonKey(name: 'seq')
  num? seq;

  @JsonKey(name: 'writeTime')
  num? writeTime;

  @JsonKey(name: 'updateTime')
  num? updateTime;

  @JsonKey(name: 'systemUser')
  String? systemUser;

  @JsonKey(name: 'status')
  num? status;

  factory ReportListInfo.fromJson(Map<String, dynamic> json) =>
      _$ReportListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ReportListInfoToJson(this);
}
