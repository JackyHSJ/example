import 'package:json_annotation/json_annotation.dart';

part 'ws_account_speak_req.g.dart';

@JsonSerializable()
class WsAccountSpeakReq {
  WsAccountSpeakReq({
    required this.roomId,
    required this.userId,
    required this.contentType,
    required this.chatContent,
    required this.uuId,
    required this.flag,
    required this.replyUuid,
    required this.giftId,
    required this.giftAmount,
    required this.isReplyPickup,
  });

  factory WsAccountSpeakReq.create(
      {
        required num roomId,
        required num userId,
        required num contentType,
        required String chatContent,
        required String uuId,
        required String flag,
        required String replyUuid,
        required String giftId,
        required String giftAmount,
        required num isReplyPickup
      }) {
    return WsAccountSpeakReq(
        roomId: roomId,
        userId: userId,
        contentType: contentType,
        chatContent: chatContent,
        uuId: uuId,
        flag: flag,
        replyUuid: replyUuid,
        giftId: giftId,
        giftAmount: giftAmount,
        isReplyPickup: isReplyPickup
    );
  }

  @JsonKey(name: 'roomId')
  num roomId;

  @JsonKey(name: 'userId')
  num userId;

  /// 0:文字訊息 1:圖片上傳 2:引言
  @JsonKey(name: 'contentType')
  num contentType;

  /// 文字內容
  @JsonKey(name: 'chatContent')
  String chatContent;

  /// uuId(32)
  @JsonKey(name: 'uuId')
  String uuId;

  /// 0:一般發話,1:重新傳送
  @JsonKey(name: 'flag')
  String flag;

  /// 女方所回复的訊息的UUID，使用逗號隔開
  @JsonKey(name: 'replyUuid')
  String replyUuid;

  /// 禮物id (金币\背包 贈禮需帶)
  @JsonKey(name: 'giftId')
  String giftId;

  /// 禮物數量 (金币\背包 贈禮需帶)
  @JsonKey(name: 'giftAmount')
  String giftAmount;

  /// 回應搭訕 0:是 1:否
  @JsonKey(name: 'isReplyPickup')
  num isReplyPickup;

  factory WsAccountSpeakReq.fromJson(Map<String, dynamic> json) =>
      _$WsAccountSpeakReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountSpeakReqToJson(this);

  Map<String, String> toBody() => toJson().map((key, value) =>
      value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
