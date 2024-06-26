
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_remark_req.g.dart';

@JsonSerializable()
class WsAccountRemarkReq {
  WsAccountRemarkReq({
    this.friendId,
    this.remark,
  });

  factory WsAccountRemarkReq.create({
    num? friendId,
    String? remark,
  }) {
    return WsAccountRemarkReq(
      friendId: friendId,
      remark: remark,
    );
  }

  @JsonKey(name: 'friendId')
  num? friendId;

  @JsonKey(name: 'remark')
  String? remark;

  factory WsAccountRemarkReq.fromJson(Map<String, dynamic> json) =>
      _$WsAccountRemarkReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountRemarkReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
