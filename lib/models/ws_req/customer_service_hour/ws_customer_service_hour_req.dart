import 'package:json_annotation/json_annotation.dart';

part 'ws_customer_service_hour_req.g.dart';

@JsonSerializable()
class WsCustomerServiceHourReq {
  WsCustomerServiceHourReq();
  factory WsCustomerServiceHourReq.create() {
    return WsCustomerServiceHourReq();
  }

  factory WsCustomerServiceHourReq.fromJson(Map<String, dynamic> json) =>
      _$WsCustomerServiceHourReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsCustomerServiceHourReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
