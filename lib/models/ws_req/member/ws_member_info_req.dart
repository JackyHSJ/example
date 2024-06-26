import 'package:json_annotation/json_annotation.dart';

part 'ws_member_info_req.g.dart';

@JsonSerializable()
class WsMemberInfoReq {
  WsMemberInfoReq({
    this.userName,
    this.id,
    this.newVisitor,
  });

  factory WsMemberInfoReq.create({
    String? userName,
    num? id,
    num? newVisitor
  }) {
    return WsMemberInfoReq(
      userName: userName,
      id: id,
      newVisitor: newVisitor
    );
  }

  /// 用戶ID
  @JsonKey(name: 'id')
   num? id;

  /// 用戶名稱
  @JsonKey(name: 'userName')
  String? userName;

  /// 用戶名稱
  @JsonKey(name: 'newVisitor')
  num? newVisitor;

  factory WsMemberInfoReq.fromJson(Map<String, dynamic> json) =>
      _$WsMemberInfoReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberInfoReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
