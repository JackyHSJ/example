import 'package:json_annotation/json_annotation.dart';

part 'ws_agent_member_list_res.g.dart';

@JsonSerializable()
class WsAgentMemberListRes {
  WsAgentMemberListRes({
    this.list
  });

  @JsonKey(name: 'list')
  List<AgentMemberInfo>? list;

  factory WsAgentMemberListRes.fromJson(Map<String, dynamic> json) =>
      _$WsAgentMemberListResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAgentMemberListResToJson(this);
}

@JsonSerializable()
class AgentMemberInfo {
  AgentMemberInfo({
    this.id,
    this.totalAmount,
    this.onlineDuration,
    this.pickup,
    this.backPackGiftAmount,
    this.totalAmountWithReward,
    this.nickName,
    this.userName,
    this.regTime,
    this.lastLoginTime,
    this.messageAmount,
    this.voiceAmount,
    this.giftAmount,
    this.videoAmount,
    this.pickupAmount,
    this.avatar,
    this.agentLevel,
    this.gender,
    this.agentUserId,
    this.parent,
    this.type,
    this.feedDonateAmount,
  });

  /// 用户ID
  @JsonKey(name: 'id')
  num? id;

  /// 总收益
  @JsonKey(name: 'totalAmount')
  num? totalAmount;

  /// 在线时长
  @JsonKey(name: 'onlineDuration')
  num? onlineDuration;

  /// 搭訕次數/次
  @JsonKey(name: 'pickup')
  num? pickup;

  /// 背包礼物金额
  @JsonKey(name: 'backPackGiftAmount')
  num? backPackGiftAmount;

  /// 总金额 (沒有值就補0)
  @JsonKey(name: 'totalAmountWithReward')
  num? totalAmountWithReward;

  /// 昵称
  @JsonKey(name: 'nickName')
  String? nickName;

  /// ID
  @JsonKey(name: 'userName')
  String? userName;

  /// 加入时间
  @JsonKey(name: 'regTime')
  num? regTime;

  /// 最近登录时间
  @JsonKey(name: 'lastLoginTime')
  num? lastLoginTime;

  /// 文字收益
  @JsonKey(name: 'messageAmount')
  num? messageAmount;

  /// 语音收益
  @JsonKey(name: 'voiceAmount')
  num? voiceAmount;

  /// 礼物收益
  @JsonKey(name: 'giftAmount')
  num? giftAmount;

  /// 视频收益
  @JsonKey(name: 'videoAmount')
  num? videoAmount;

  /// 搭讪收益
  @JsonKey(name: 'pickupAmount')
  num? pickupAmount;

  /// 頭像
  @JsonKey(name: 'avatar')
  String? avatar;

  /// 所屬層級1/2/0 一級推廣/二級推廣/普通成員
  @JsonKey(name: 'agentLevel')
  num? agentLevel;

  @JsonKey(name: 'gender')
  num? gender;

  @JsonKey(name: 'agentUserId')
  num? agentUserId;

  @JsonKey(name: 'parent')
  num? parent;

  /// 会员类型 二级推广:agentLevel>0，为agentLevel级推广; 推广人脉:agentUserId=Param userId; 普通成员:agentUserId!=Param userId
  @JsonKey(name: 'type')
  num? type;

  /// 动态打赏收益
  @JsonKey(name: 'feedDonateAmount')
  num? feedDonateAmount;

  factory AgentMemberInfo.fromJson(Map<String, dynamic> json) =>
      _$AgentMemberInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AgentMemberInfoToJson(this);
}
