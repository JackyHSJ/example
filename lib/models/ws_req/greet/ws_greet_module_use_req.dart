import 'package:json_annotation/json_annotation.dart';

part 'ws_greet_module_use_req.g.dart';

@JsonSerializable()
class WsGreetModuleUseReq {
  WsGreetModuleUseReq({
    this.id,
    this.status
  });

  factory WsGreetModuleUseReq.create({
    num? id,
    num? status
  }) {
    return WsGreetModuleUseReq(
      id: id,
      status: status
    );
  }

  /// 模板id
  @JsonKey(name: 'id')
  num? id;

  /// 狀態 0:未使用 1:使用中
  @JsonKey(name: 'status')
  num? status;

  factory WsGreetModuleUseReq.fromJson(Map<String, dynamic> json) =>
      _$WsGreetModuleUseReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsGreetModuleUseReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
