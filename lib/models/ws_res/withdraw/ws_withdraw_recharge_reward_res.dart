import 'package:json_annotation/json_annotation.dart';

part 'ws_withdraw_recharge_reward_res.g.dart';


@JsonSerializable()
class WsWithdrawRechargeRewardRes {
  WsWithdrawRechargeRewardRes({
    this.newUserChargeReward,
  });

  factory WsWithdrawRechargeRewardRes.create({UserChargeReward? newUserChargeReward}) {
    return WsWithdrawRechargeRewardRes(
      newUserChargeReward: newUserChargeReward,
    );
  }

  // 充值配置
  @JsonKey(name: 'newUserChargeReward')
  UserChargeReward? newUserChargeReward;

  factory WsWithdrawRechargeRewardRes.fromJson(Map<String, dynamic> json) => _$WsWithdrawRechargeRewardResFromJson(json);
  Map<String, dynamic> toJson() => _$WsWithdrawRechargeRewardResToJson(this);
}

@JsonSerializable()
class UserChargeReward {

  UserChargeReward({
    this.androidFristChargeGift,
    this.iosFristChargeGift,
  });

  factory UserChargeReward.create({
    List<ChargeGift>? androidFristChargeGift,
    List<ChargeGift>? iosFristChargeGift
  }) {
    return UserChargeReward(
        androidFristChargeGift: androidFristChargeGift,
        iosFristChargeGift: iosFristChargeGift
    );
  }

  // android 獎勵
  @JsonKey(name: 'androidFristChargeGift')
  List<ChargeGift>? androidFristChargeGift;

  // ios 獎勵
  @JsonKey(name: 'iosFristChargeGift')
  List<ChargeGift>? iosFristChargeGift;

  factory UserChargeReward.fromJson(Map<String, dynamic> json) =>
      _$UserChargeRewardFromJson(json);

  Map<String, dynamic> toJson() => _$UserChargeRewardToJson(this);
}

@JsonSerializable()
class ChargeGift {

  ChargeGift({
    required this.id,
    required this.giftId,
    required this.giftType,
    required this.sendAmount,
    required this.giftImageUrl,
    required this.giftName,
  });

  factory ChargeGift.create({
    num? id,
    num? giftId,
    num? giftType,
    dynamic? sendAmount,
    String? giftImageUrl,
    String? giftName,
  }) {
    return ChargeGift(
        id: id,
        giftId: giftId,
        giftType: giftType,
        sendAmount: sendAmount,
        giftImageUrl: giftImageUrl,
        giftName: giftName
    );
  }

  // 用户ID.
  @JsonKey(name: 'id')
  num? id;

  // 禮物ID
  @JsonKey(name: 'giftId')
  num? giftId;

  // 禮物類別0金幣/1背包禮物
  @JsonKey(name: 'giftType')
  num? giftType;

  // 贈送金額(只給金幣用)
  @JsonKey(name: 'sendAmount')
  dynamic? sendAmount;

  // 禮物 Url
  @JsonKey(name: 'giftImageUrl')
  String? giftImageUrl;

  // 禮物名稱
  @JsonKey(name: 'giftName')
  String? giftName;

  factory ChargeGift.fromJson(Map<String, dynamic> json) =>
      _$ChargeGiftFromJson(json);

  Map<String, dynamic> toJson() => _$ChargeGiftToJson(this);
}

