import 'package:encrypt/encrypt.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../system/comm/comm_def.dart';
import '../../system/util/aes_util.dart';

part 'ws_base_req.g.dart';

@JsonSerializable()
class WsBaseReq {
  WsBaseReq({
    required this.f,
    required this.tId,
    required this.msg,
    this.rId,
  });

  factory WsBaseReq.create({
    required String f,
    required String tId,
    required String msg,
    String? rId
  }) {
    return WsBaseReq(f: f, tId: tId, msg: msg, rId: rId);
  }

  @JsonKey(name: 'rId')
  String? rId;

  @JsonKey(name: 'f')
  String f;

  @JsonKey(name: 'tId')
  String tId;

  @JsonKey(name: 'msg')
  dynamic msg;

  factory WsBaseReq.fromJson(Map<String, dynamic> json) =>
      _$WsBaseReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsBaseReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
