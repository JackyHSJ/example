
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_base_res.g.dart';

@JsonSerializable()
class WsBaseRes {
  WsBaseRes({
    this.f,
    this.resultCode,
    this.resultMsg,
    this.resultMap,
    this.rId,
  });

  @JsonKey(name: 'rId')
  final String? rId;

  @JsonKey(name: 'f')
  final String? f;

  @JsonKey(name: 'resultCode')
  final String? resultCode;

  @JsonKey(name: 'resultMsg')
  final String? resultMsg;

  @JsonKey(name: 'resultMap')
  final dynamic resultMap;

  factory WsBaseRes.fromJson(Map<String, dynamic> json) =>
      _$WsBaseResFromJson(json);
  Map<String, dynamic> toJson() => _$WsBaseResToJson(this);



  printLog() {
    debugPrint('===========printWebSocketResponseLog===========');
    debugPrint('rId:$rId');
    debugPrint('resultCode:$resultCode');
    debugPrint('resultMsg:$resultMsg');
    debugPrint('resultMap:$resultMap');
    debugPrint('f:$f');
  }
}