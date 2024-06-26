import 'package:encrypt/encrypt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_greet_module_list_req.g.dart';

@JsonSerializable()
class WsGreetModuleListReq {
  WsGreetModuleListReq();

  factory WsGreetModuleListReq.create() {
    return WsGreetModuleListReq();
  }

  factory WsGreetModuleListReq.fromJson(Map<String, dynamic> json) =>
      _$WsGreetModuleListReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsGreetModuleListReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
