import 'package:json_annotation/json_annotation.dart';

part 'ws_member_new_user_to_top_list_res.g.dart';

@JsonSerializable()
class WsMemberNewUserToTopListRes {
  WsMemberNewUserToTopListRes();

  factory WsMemberNewUserToTopListRes.fromJson(Map<String, dynamic> json) =>
      _$WsMemberNewUserToTopListResFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberNewUserToTopListResToJson(this);
}
