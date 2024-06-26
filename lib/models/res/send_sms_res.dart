import 'package:json_annotation/json_annotation.dart';

part 'send_sms_res.g.dart';

@JsonSerializable()
class SendSmsRes {
  SendSmsRes({
    this.isSend,
    this.dailyLimit,
  });

  @JsonKey(name: 'isSend')
  final bool? isSend;

  @JsonKey(name: 'dailyLimit')
  final num? dailyLimit;

  factory SendSmsRes.fromJson(Map<String, dynamic> json) =>
      _$SendSmsMapFromJson(json);
  Map<String, dynamic> toJson() => _$SendSmsResToJson(this);
}
