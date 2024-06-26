import 'package:encrypt/encrypt.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../system/comm/comm_def.dart';
import '../../system/util/aes_util.dart';

part 'error_log_req.g.dart';

@JsonSerializable()
class ErrorLogReq {
  ErrorLogReq({
    this.delayTime,
    this.userName,
    this.funcCode,
    this.resultCode,
    this.resultMsg,
  });

  factory ErrorLogReq.create({
    String? delayTime,
    String? userName,
    String? funcCode,
    String? resultCode,
    dynamic resultMsg
  }) {
    return ErrorLogReq(
      delayTime: delayTime,
      userName: userName,
      funcCode: funcCode,
      resultCode: resultCode,
      resultMsg: resultMsg,
    );
  }

  @JsonKey(name: 'delayTime')
  String? delayTime;

  @JsonKey(name: 'userName')
  String? userName;

  @JsonKey(name: 'funcCode')
  String? funcCode;

  @JsonKey(name: 'resultCode')
  String? resultCode;

  @JsonKey(name: 'resultMsg')
  dynamic resultMsg;

  factory ErrorLogReq.fromJson(Map<String, dynamic> json) =>
      _$ErrorLogReqFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorLogReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
