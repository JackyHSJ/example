import 'package:json_annotation/json_annotation.dart';

part 'zim_message_content.g.dart';

@JsonSerializable()
class ZimMessageContent {
  ZimMessageContent({
    required this.uuid,
    required this.type,
    required this.giftId,
    required this.giftCount,
    required this.giftUrl,
    required this.giftName,
    required this.content,
  });

  factory ZimMessageContent.fromJson(Map<String, dynamic> json) =>
      _$ZimMessageContentFromJson(json);
  Map<String, dynamic> toJson() => _$ZimMessageContentToJson(this);

  // UUID
  @JsonKey(name: 'uuid')
  String uuid;

  // Type
  @JsonKey(name: 'type')
  num type;

  // Gift ID
  @JsonKey(name: 'giftId')
  String giftId;

  // Gift Count
  @JsonKey(name: 'giftCount')
  String giftCount;

  // Gift URL
  @JsonKey(name: 'giftUrl')
  String giftUrl;

  // Gift Name
  @JsonKey(name: 'giftName')
  String giftName;

  // Content
  @JsonKey(name: 'content')
  String content;
}