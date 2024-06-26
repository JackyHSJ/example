
import 'package:json_annotation/json_annotation.dart';

part 'ws_mission_get_award_req.g.dart';

@JsonSerializable()
class WsMissionGetAwardReq {
  WsMissionGetAwardReq({
    required this.target,
  });

  factory WsMissionGetAwardReq.create({
    required String target,
  }) {
    return WsMissionGetAwardReq(
      target: target,
    );
  }

  /// 任務目標
  /// 0:完善资料(新手) 1:上傳頭像(新手) 2:完善相冊(新手)
  /// 3:個性簽名(新手) 4:搭訕小姐姐/小哥哥(每日) 5:邀请好友(每日)
  /// 6:视频通话(每日) 7:语音通话(每日) 8:發送私信(每日)
  @JsonKey(name: 'target')
  String target;

  factory WsMissionGetAwardReq.fromJson(Map<String, dynamic> json) =>
      _$WsMissionGetAwardReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsMissionGetAwardReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
