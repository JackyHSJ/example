import 'package:json_annotation/json_annotation.dart';

part 'report_user_res.g.dart';

@JsonSerializable()
class ReportUserRes {
  ReportUserRes({
    required this.freReportId,
  });

  // 舉報Id流水號
  @JsonKey(name: 'freReportId')
  num? freReportId;

  factory ReportUserRes.fromJson(Map<String, dynamic> json) =>
      _$ReportUserMapFromJson(json);
  Map<String, dynamic> toJson() => _$ReportUserResToJson(this);
}
