
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_follow_and_fans_list_req.g.dart';

@JsonSerializable()
class WsAccountFollowAndFansListReq {
  WsAccountFollowAndFansListReq({
    this.type,
    this.page,
  });

  factory WsAccountFollowAndFansListReq.create({
    num? type,
    String? page,
  }) {
    return WsAccountFollowAndFansListReq(
      type: type,
      page: page,
    );
  }

  @JsonKey(name: 'type')
  num? type;

  @JsonKey(name: 'page')
  String? page;
  
  factory WsAccountFollowAndFansListReq.fromJson(Map<String, dynamic> json) =>
      _$WsAccountFollowAndFansListReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountFollowAndFansListReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
