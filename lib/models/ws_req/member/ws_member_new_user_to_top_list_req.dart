import 'package:frechat/system/util/aes_util.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_member_new_user_to_top_list_req.g.dart';

@JsonSerializable()
class WsMemberNewUserToTopListReq {
  WsMemberNewUserToTopListReq();

  factory WsMemberNewUserToTopListReq.create() {
    return WsMemberNewUserToTopListReq();
  }

  factory WsMemberNewUserToTopListReq.fromJson(Map<String, dynamic> json) =>
      _$WsMemberNewUserToTopListReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberNewUserToTopListReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
