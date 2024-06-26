import 'package:encrypt/encrypt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_greet_module_delete_req.g.dart';

@JsonSerializable()
class WsGreetModuleDeleteReq {
  WsGreetModuleDeleteReq({
    this.ids,
  });

  factory WsGreetModuleDeleteReq.create({
    String? ids,
  }) {
    return WsGreetModuleDeleteReq(
      ids: ids,
    );
  }

  /// 模板ids ,分隔 1,2,3
  @JsonKey(name: 'ids')
  String? ids;

  factory WsGreetModuleDeleteReq.fromJson(Map<String, dynamic> json) =>
      _$WsGreetModuleDeleteReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsGreetModuleDeleteReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
