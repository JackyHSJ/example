import 'package:json_annotation/json_annotation.dart';

part 'ws_customer_service_hour_res.g.dart';

@JsonSerializable()
class WsCustomerServiceHourRes {
  WsCustomerServiceHourRes({
    this.duration,
});

  @JsonKey(name: 'duration')
  String? duration;

  factory WsCustomerServiceHourRes.fromJson(Map<String, dynamic> json) =>
      _$WsCustomerServiceHourResFromJson(json);
  Map<String, dynamic> toJson() => _$WsCustomerServiceHourResToJson(this);
}