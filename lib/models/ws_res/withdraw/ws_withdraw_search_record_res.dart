import 'package:json_annotation/json_annotation.dart';

part 'ws_withdraw_search_record_res.g.dart';

@JsonSerializable()
class WsWithdrawSearchRecordRes {
  WsWithdrawSearchRecordRes({
    this.pageNumber,
    this.totalPages,
    this.fullListSize,
    this.pageSize,
    this.list,
  });

  factory WsWithdrawSearchRecordRes.create({
    num? pageNumber,
    num? totalPages,
    num? fullListSize,
    num? pageSize,
    List<WithdrawListInfo>? list
  }) {
    return WsWithdrawSearchRecordRes(
        pageNumber: pageNumber,
        totalPages: totalPages,
        fullListSize: fullListSize,
        pageSize: pageSize,
        list: list
    );
  }

  /// 當前分頁數
  @JsonKey(name: 'pageNumber')
  num? pageNumber;

  /// 總頁數
  @JsonKey(name: 'totalPages')
  num? totalPages;

  /// 總資料筆數
  @JsonKey(name: 'fullListSize')
  num? fullListSize;

  /// 一分頁顯示幾筆資料
  @JsonKey(name: 'pageSize')
  num? pageSize;

  @JsonKey(name: 'list')
  List<WithdrawListInfo>? list;

  factory WsWithdrawSearchRecordRes.fromJson(Map<String, dynamic> json) =>
      _$WsWithdrawSearchRecordResFromJson(json);
  Map<String, dynamic> toJson() => _$WsWithdrawSearchRecordResToJson(this);
}

class WithdrawListInfo {
  WithdrawListInfo({
    this.withdrawalId,
    this.transactionId,
    this.checkId,
    this.point,
    this.expectAmount,
    this.serviceAmount,
    this.realAmount,
    this.status,
    this.freUserId,
    this.nickName,
    this.createTime,
    this.updateTime,
    this.badAmount,
    this.remark,
  });

  factory WithdrawListInfo.create({
    num? withdrawalId,
    String? transactionId,
    String? checkId,
    num? point,
    num? expectAmount,
    num? serviceAmount,
    num? realAmount,
    num? status,
    num? freUserId,
    String? nickName,
    num? createTime,
    num? updateTime,
    num? badAmount,
    String? remark,
  }) {
    return WithdrawListInfo(
      withdrawalId: withdrawalId,
      transactionId: transactionId,
      checkId: checkId,
      point: point,
      expectAmount: expectAmount,
      serviceAmount: serviceAmount,
      realAmount: realAmount,
      status: status,
      freUserId: freUserId,
      nickName: nickName,
      createTime: createTime,
      updateTime: updateTime,
      badAmount: badAmount,
      remark: remark,
    );
  }

  /// pk
  @JsonKey(name: 'withdrawalId')
  num? withdrawalId;

  /// 交易號(WWY開頭為微信, WAP開頭為支付寶, WiOS開頭為蘋果)
  @JsonKey(name: 'transactionId')
  String? transactionId;

  /// 對帳號
  @JsonKey(name: 'checkId')
  String? checkId;

  /// 提現積分
  @JsonKey(name: 'point')
  num? point;

  /// 提現金額
  @JsonKey(name: 'expectAmount')
  num? expectAmount;

  /// 服務費
  @JsonKey(name: 'serviceAmount')
  num? serviceAmount;

  /// 實到金額
  @JsonKey(name: 'realAmount')
  num? realAmount;

  /// 提現狀態: 0:提现中 1:提现成功 2:提现被拒 3:提现失败
  @JsonKey(name: 'status')
  num? status;

  /// 用戶 ID
  @JsonKey(name: 'freUserId')
  num? freUserId;

  /// 用戶暱稱
  @JsonKey(name: 'nickName')
  String? nickName;

  /// 建立時間(unix timestamp)
  @JsonKey(name: 'createTime')
  num? createTime;

  /// 更新時間(unix timestamp)
  @JsonKey(name: 'updateTime')
  num? updateTime;

  /// 壞帳金額
  @JsonKey(name: 'badAmount')
  num? badAmount;

  /// 備註
  @JsonKey(name: 'remark')
  String? remark;

  factory WithdrawListInfo.fromJson(Map<String, dynamic> json) =>
      _$WithdrawListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$WithdrawListInfoToJson(this);
}