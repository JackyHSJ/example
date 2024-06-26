

import 'package:frechat/models/ws_res/detail/ws_detail_search_list_coin_res.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_contact_search_friend_benefit_res.g.dart';

@JsonSerializable()
class WsContactSearchFriendBenefitRes {
  WsContactSearchFriendBenefitRes({
    this.pageNumber,
    this.totalPages,
    this.fullListSize,
    this.pageSize,
    this.list,
  });

  factory WsContactSearchFriendBenefitRes.create({
    num? pageNumber,
    num? totalPages,
    num? fullListSize,
    num? pageSize,
    List<ContactFriendListInfo>? list
  }) {
    return WsContactSearchFriendBenefitRes(
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
  List<ContactFriendListInfo>? list;

  factory WsContactSearchFriendBenefitRes.fromJson(Map<String, dynamic> json) =>
      _$WsContactSearchFriendBenefitResFromJson(json);
  Map<String, dynamic> toJson() => _$WsContactSearchFriendBenefitResToJson(this);
}

class ContactFriendListInfo {
  ContactFriendListInfo({
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
    this.avatar,
    this.age,
    this.gender,
    this.realPersonAuth,
    this.realNameAuth,
  });

  factory ContactFriendListInfo.create({
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
    num? age,
    num? gender,
    num? realPersonAuth,
    num? realNameAuth
  }) {
    return ContactFriendListInfo(
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
        age: age,
        gender: gender,
        realPersonAuth: realPersonAuth,
        realNameAuth: realNameAuth
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

  /// 幣別 0:金幣 1:積分
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

  @JsonKey(name: 'phoneNumber')
  String? phoneNumber;

  /// 帳變類型
  /// 0:金幣-視頻通話消耗 1:金幣-視頻通話免費 2:金幣-語音通話消耗
  /// 3:金幣-語音通話免費 4:金幣-文字消息消耗 5:金幣-文字消息免費
  /// 6:金幣-打賞禮物消耗 7:金幣-背包禮物消耗 8:金幣-充值贈送金幣
  /// 9:金幣-签到贈送 10:金幣-活動贈送 11:金幣-充值金幣 12:金幣-退回金幣
  /// 13:金幣-積分兌換金幣(金幣增加) 14:金幣-註冊獎勵 15:積分-邀请獎勵積分(充值)
  /// 16:積分-邀请獎勵積分(收益) 17:積分-视频收益 18:積分-视屏免费 19:積分-语音收益
  /// 20:積分-语音免费 21:積分-文字收益 22:積分-文字免费 23:積分-礼物收益
  /// 24:積分-背包礼物收益 25:積分-活动积分收益 26:積分-积分兑换金币 (積分減少)
  /// 27:積分-提现积分 28:積分-提现失败 29:金幣-人工减金币
  @JsonKey(name: 'type')
  num? type;

  @JsonKey(name: 'interactFreUserId')
  num? interactFreUserId;

  @JsonKey(name: 'interactFreUserName')
  String? interactFreUserName;

  @JsonKey(name: 'avatar')
  String? avatar;

  @JsonKey(name: 'age')
  num? age;

  @JsonKey(name: 'gender')
  num? gender;

  @JsonKey(name: 'realPersonAuth')
  num? realPersonAuth;

  @JsonKey(name: 'realNameAuth')
  num? realNameAuth;


  factory ContactFriendListInfo.fromJson(Map<String, dynamic> json) =>
      _$ContactFriendListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ContactFriendListInfoToJson(this);
}

