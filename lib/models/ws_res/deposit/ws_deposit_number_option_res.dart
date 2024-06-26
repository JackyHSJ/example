import 'package:json_annotation/json_annotation.dart';

part 'ws_deposit_number_option_res.g.dart';

@JsonSerializable()
class WsDepositNumberOptionRes {
  WsDepositNumberOptionRes({this.list});

  factory WsDepositNumberOptionRes.create({List<DepositOptionListInfo>? list}) {
    return WsDepositNumberOptionRes(
      list: list
    );
  }

  /// 當前頁數
  @JsonKey(name: 'list')
  List<DepositOptionListInfo>? list;

  factory WsDepositNumberOptionRes.fromJson(Map<String, dynamic> json) =>
      _$WsDepositNumberOptionResFromJson(json);
  Map<String, dynamic> toJson() => _$WsDepositNumberOptionResToJson(this);
}

@JsonSerializable()
class DepositOptionListInfo {
  DepositOptionListInfo({
    this.amount,
    this.appConfigId,
    this.appleId,
    this.createTime,
    this.depositCoinsConfigId,
    this.vipCoins,
    this.seq,
    this.coins,
    this.type,
    this.fistType,
});

  /// 金額(人民幣)
  @JsonKey(name: 'amount')
  num? amount;

  ///
  @JsonKey(name: 'appConfigId')
  num? appConfigId;

  ///
  @JsonKey(name: 'appleId')
  String? appleId;

  /// 金币
  @JsonKey(name: 'coins')
  num? coins;

  ///
  @JsonKey(name: 'createTime')
  num? createTime;

  ///
  @JsonKey(name: 'depositCoinsConfigId')
  num? depositCoinsConfigId;

  ///
  @JsonKey(name: 'seq')
  num? seq;

  ///
  @JsonKey(name: 'vipCoins')
  num? vipCoins;

  /// 平台類型: 0:ios 1:android
  @JsonKey(name: 'type')
  num? type;

  /// 是否為第一次充值 (是否首充 0:否 1:是)
  @JsonKey(name: 'fistType')
  num? fistType;



  factory DepositOptionListInfo.fromJson(Map<String, dynamic> json) =>
      _$DepositOptionListInfoResFromJson(json);
  Map<String, dynamic> toJson() => _$DepositOptionListInfoToJson(this);
}