import 'package:encrypt/encrypt.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../system/comm/comm_def.dart';
import '../../system/util/aes_util.dart';

part 'member_logout_req.g.dart';

@JsonSerializable()
class MemberLogoutReq {
  MemberLogoutReq({
    required this.tId,
  });

  factory MemberLogoutReq.create({
    required String tId,
  }) {
    return MemberLogoutReq(tId: tId);
  }

  // token
  @JsonKey(name: 'tId')
  String tId;

  factory MemberLogoutReq.fromJson(Map<String, dynamic> json) =>
      _$MemberLogoutReqFromJson(json);
  Map<String, dynamic> toJson() => _$MemberLogoutReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
