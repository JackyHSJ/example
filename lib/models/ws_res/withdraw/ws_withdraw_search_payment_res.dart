import 'package:json_annotation/json_annotation.dart';

part 'ws_withdraw_search_payment_res.g.dart';

@JsonSerializable()
class WsWithdrawSearchPaymentRes {
  WsWithdrawSearchPaymentRes({
    this.idCard,
    this.realName,
    this.list,
  });

  /// 身份證
  @JsonKey(name: 'idCard')
  String? idCard;

  /// 真實姓名
  @JsonKey(name: 'realName')
  String? realName;

  /// 當前分頁數
  @JsonKey(name: 'list')
  List<WithdrawPaymentListInfo>? list;

  factory WsWithdrawSearchPaymentRes.fromJson(Map<String, dynamic> json) => _$WsWithdrawSearchPaymentResFromJson(json);
  Map<String, dynamic> toJson() => _$WsWithdrawSearchPaymentResToJson(this);
}

class WithdrawPaymentListInfo {
  WithdrawPaymentListInfo({
    this.account,
    this.createTime,
    this.type,
    this.updateTime,
    this.userId,
    this.withdrawalAccountId,
    this.status,
  });

  @JsonKey(name: 'account')
  String? account;

  @JsonKey(name: 'createTime')
  num? createTime;

  @JsonKey(name: 'type')
  num? type;

  @JsonKey(name: 'updateTime')
  num? updateTime;

  @JsonKey(name: 'userId')
  num? userId;

  @JsonKey(name: 'withdrawalAccountId')
  num? withdrawalAccountId;

  /// 用户預設帳號 0:未指定 1:指定.
  @JsonKey(name: 'status')
  num? status;

  factory WithdrawPaymentListInfo.fromJson(Map<String, dynamic> json) => _$WithdrawPaymentListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$WithdrawPaymentListInfoToJson(this);
}
