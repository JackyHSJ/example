import 'package:json_annotation/json_annotation.dart';

part 'ws_detail_search_list_coin_res.g.dart';

@JsonSerializable()
class WsDetailSearchListCoinRes {
  WsDetailSearchListCoinRes({
    this.pageNumber,
    this.totalPages,
    this.fullListSize,
    this.pageSize,
    this.list,
  });

  factory WsDetailSearchListCoinRes.create({num? pageNumber, num? totalPages, num? fullListSize, num? pageSize, List<DetailListInfo>? list}) {
    return WsDetailSearchListCoinRes(
      pageNumber: pageNumber,
      totalPages: totalPages,
      fullListSize: fullListSize,
      pageSize: pageSize,
      list: list,
    );
  }

  /// 當前頁數
  @JsonKey(name: 'pageNumber')
  num? pageNumber;

  /// 總頁數
  @JsonKey(name: 'totalPages')
  num? totalPages;

  /// 總筆數
  @JsonKey(name: 'fullListSize')
  num? fullListSize;

  /// 每頁筆數
  @JsonKey(name: 'pageSize')
  num? pageSize;

  /// list
  @JsonKey(name: 'list')
  List<DetailListInfo>? list;

  factory WsDetailSearchListCoinRes.fromJson(Map<String, dynamic> json) => _$WsDetailSearchListCoinResFromJson(json);
  Map<String, dynamic> toJson() => _$WsDetailSearchListCoinResToJson(this);
}

class DetailListInfo {
  DetailListInfo({
    this.afterBalance,
    this.amount,
    this.beforeBalance,
    this.createTime,
    this.currency,
    this.freUserId,
    this.fundHistoryId,
    this.fundHistoryJson,
    this.phoneNumber,
    this.type,
    this.interactFreUserId,
    this.interactFreUserName,
    this.age,
    this.gender,
    this.realNameAuth,
    this.realPersonAuth,
    this.avatar,
  });

  factory DetailListInfo.create({
    num? afterBalance,
    num? amount,
    num? beforeBalance,
    num? createTime,
    num? currency,
    num? freUserId,
    num? fundHistoryId,
    FundHistoryJsonInfo? fundHistoryJson,
    String? phoneNumber,
    num? type,
    num? interactFreUserId,
    String? interactFreUserName,
    String? avatar,
  }) {
    return DetailListInfo(
      afterBalance: afterBalance,
      amount: amount,
      beforeBalance: beforeBalance,
      createTime: createTime,
      currency: currency,
      freUserId: freUserId,
      fundHistoryId: fundHistoryId,
      fundHistoryJson: fundHistoryJson,
      phoneNumber: phoneNumber,
      type: type,
      interactFreUserId: interactFreUserId,
      interactFreUserName: interactFreUserName,
      avatar: avatar,
    );
  }

  /// 剩餘金額
  @JsonKey(name: 'afterBalance')
  num? afterBalance;

  /// 帳變金額(支出為負值)
  @JsonKey(name: 'amount')
  num? amount;

  /// 之前餘額
  @JsonKey(name: 'beforeBalance')
  num? beforeBalance;

  /// 建立時間
  @JsonKey(name: 'createTime')
  num? createTime;

  /// 幣別 0:金币 1:積分
  @JsonKey(name: 'currency')
  num? currency;

  /// 用戶id (前台畫面無需顯示)
  @JsonKey(name: 'freUserId')
  num? freUserId;

  /// 帳變id (前台畫面無需顯示)
  @JsonKey(name: 'fundHistoryId')
  num? fundHistoryId;

  /// 備註 (可存產生帳變之對象資訊, 為 json 格式)
  @JsonKey(name: 'fundHistoryJson')
  FundHistoryJsonInfo? fundHistoryJson;

  /// 手機號
  @JsonKey(name: 'phoneNumber')
  String? phoneNumber;

  /// 帳變類型:
  /// 0:視頻通話消耗 1:視頻通話免費 2:語音通話消耗 3:語音通話免費
  /// 4:文字消息消耗 5:文字消息免費 6:打賞禮物消耗 7:背包禮物消耗
  /// 8:充值贈送金币 9:签到贈送 10:活動贈送 11:充值金币
  /// 12:退回金币 13:積分兌換金币 14:註冊獎勵
  @JsonKey(name: 'type')
  num? type;

  /// 對象 user id
  @JsonKey(name: 'interactFreUserId')
  num? interactFreUserId;

  /// 對象 nick name
  @JsonKey(name: 'interactFreUserName')
  String? interactFreUserName;

  /// 用户头像路径。
  @JsonKey(name: 'avatar')
  String? avatar;

  /// 用户实名认证状态。
  @JsonKey(name: 'realNameAuth')
  num? realNameAuth;

  /// 用户实人认证状态。
  @JsonKey(name: 'realPersonAuth')
  num? realPersonAuth;

  /// 用户性别。
  @JsonKey(name: 'gender')
  num? gender;

  /// 用户年龄。
  @JsonKey(name: 'age')
  num? age;

  factory DetailListInfo.fromJson(Map<String, dynamic> json) => _$DetailListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DetailListInfoToJson(this);
}

class FundHistoryJsonInfo {
  FundHistoryJsonInfo({this.interactFreUserId, this.interactNickName, this.giftId, this.giftCoins});

  factory FundHistoryJsonInfo.create({String? interactFreUserId, String? interactNickName, num? giftId, num? giftCoins}) {
    return FundHistoryJsonInfo(interactFreUserId: interactFreUserId, interactNickName: interactNickName, giftId: giftId,giftCoins: giftCoins );
  }

  /// 對象 user id
  @JsonKey(name: 'interactFreUserId')
  String? interactFreUserId;

  /// 對象 nick name
  @JsonKey(name: 'interactNickName')
  String? interactNickName;

  /// giftId
  @JsonKey(name: 'giftId')
  num? giftId;

  /// 對象 nick name
  @JsonKey(name: 'giftCoins')
  num? giftCoins;



  factory FundHistoryJsonInfo.fromJson(Map<String, dynamic> json) => _$FundHistoryJsonInfoFromJson(json);
  Map<String, dynamic> toJson() => _$FundHistoryJsonInfoToJson(this);
}
