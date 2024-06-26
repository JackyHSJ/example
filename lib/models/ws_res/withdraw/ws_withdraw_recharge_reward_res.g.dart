// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_withdraw_recharge_reward_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsWithdrawRechargeRewardRes _$WsWithdrawRechargeRewardResFromJson(
    Map<String, dynamic> json) =>
    WsWithdrawRechargeRewardRes(
      newUserChargeReward: json['newUserChargeReward'] == null
          ? null
          : UserChargeReward.fromJson(
          json['newUserChargeReward'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WsWithdrawRechargeRewardResToJson(
    WsWithdrawRechargeRewardRes instance) =>
    <String, dynamic>{
      'newUserChargeReward': instance.newUserChargeReward,
    };

UserChargeReward _$UserChargeRewardFromJson(Map<String, dynamic> json) =>
    UserChargeReward(
      androidFristChargeGift: (json['androidFristChargeGift'] as List<dynamic>?)
          ?.map((e) => ChargeGift.fromJson(e as Map<String, dynamic>))
          .toList(),
      iosFristChargeGift: (json['iosFristChargeGift'] as List<dynamic>?)
          ?.map((e) => ChargeGift.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserChargeRewardToJson(UserChargeReward instance) =>
    <String, dynamic>{
      'androidFristChargeGift': instance.androidFristChargeGift,
      'iosFristChargeGift': instance.iosFristChargeGift,
    };

ChargeGift _$ChargeGiftFromJson(Map<String, dynamic> json) => ChargeGift(
  id: json['id'] as num?,
  giftId: json['giftId'] as num?,
  giftType: json['giftType'] as num?,
  sendAmount: json['sendAmount'] as dynamic?,
  giftImageUrl: json['giftImageUrl'] as String?,
  giftName: json['giftName'] as String?,
);

Map<String, dynamic> _$ChargeGiftToJson(ChargeGift instance) =>
    <String, dynamic>{
      'id': instance.id,
      'giftId': instance.giftId,
      'giftType': instance.giftType,
      'sendAmount': instance.sendAmount,
      'giftImageUrl': instance.giftImageUrl,
      'giftName': instance.giftName,
    };
