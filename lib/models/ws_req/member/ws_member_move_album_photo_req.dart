import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/screens/profile/edit/personal_edit_view_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_member_move_album_photo_req.g.dart';

@JsonSerializable()
class WsMemberMoveAlbumPhotoReq {
  WsMemberMoveAlbumPhotoReq({
    this.albumsPath,
  });

  factory WsMemberMoveAlbumPhotoReq.create({
    List<AlbumsPathInfo>? albumsPath,
  }) {
    return WsMemberMoveAlbumPhotoReq(
      albumsPath: albumsPath,
    );
  }

  /// 用戶ID
  @JsonKey(name: 'albumsPath')
  List<AlbumsPathInfo>? albumsPath;

  factory WsMemberMoveAlbumPhotoReq.fromJson(Map<String, dynamic> json) =>
      _$WsMemberMoveAlbumPhotoReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberMoveAlbumPhotoReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
