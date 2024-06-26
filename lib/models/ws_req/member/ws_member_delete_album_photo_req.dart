import 'package:json_annotation/json_annotation.dart';

part 'ws_member_delete_album_photo_req.g.dart';

@JsonSerializable()
class WsMemberDeleteAlbumPhotoReq {
  WsMemberDeleteAlbumPhotoReq({
    this.id,
  });

  factory WsMemberDeleteAlbumPhotoReq.create({
    num? id
  }) {
    return WsMemberDeleteAlbumPhotoReq(
      id: id
    );
  }

  /// 檔案id
  @JsonKey(name: 'id')
   num? id;

  factory WsMemberDeleteAlbumPhotoReq.fromJson(Map<String, dynamic> json) =>
      _$WsMemberDeleteAlbumPhotoReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberDeleteAlbumPhotoReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
