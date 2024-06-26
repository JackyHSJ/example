import 'package:frechat/models/ws_res/detail/ws_detail_search_list_coin_res.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_contact_invite_friend_res.g.dart';

@JsonSerializable()
class WsContactInviteFriendRes {
  WsContactInviteFriendRes({
    this.income,
    this.deposit,
    this.userName,
  });

  factory WsContactInviteFriendRes.create({
    num? income,
    num? deposit,
    String? userName,
}) {
    return WsContactInviteFriendRes(
      income: income,
      deposit: deposit,
      userName: userName,
    );
  }

  /// 收益分成比例
  @JsonKey(name: 'income')
  num? income;

  /// 充值分成比例
  @JsonKey(name: 'deposit')
  num? deposit;

  @JsonKey(name: 'userName')
  String? userName;

  factory WsContactInviteFriendRes.fromJson(Map<String, dynamic> json) =>
      _$WsContactInviteFriendResFromJson(json);
  Map<String, dynamic> toJson() => _$WsContactInviteFriendResToJson(this);
}