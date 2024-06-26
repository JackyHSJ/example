import 'package:encrypt/encrypt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_greet_module_edit_remark_req.g.dart';

@JsonSerializable()
class WsGreetModuleEditRemarkReq {
  WsGreetModuleEditRemarkReq({
    this.id,
    this.modelName,
  });

  factory WsGreetModuleEditRemarkReq.create({
    num? id,
    String? modelName
  }) {
    return WsGreetModuleEditRemarkReq(
      id: id,
      modelName: modelName
    );
  }

  /// 模板id
  @JsonKey(name: 'id')
  num? id;

  /// 模板備註
  @JsonKey(name: 'modelName')
  String? modelName;

  factory WsGreetModuleEditRemarkReq.fromJson(Map<String, dynamic> json) =>
      _$WsGreetModuleEditRemarkReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsGreetModuleEditRemarkReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
