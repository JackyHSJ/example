import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_member_move_album_photo_res.g.dart';

@JsonSerializable()
class WsMemberMoveAlbumPhotoRes {
  WsMemberMoveAlbumPhotoRes({
    this.albumsPath,
  });

  /// 相簿地址
  @JsonKey(name: 'albumsPath')
  List<AlbumsPathInfo>? albumsPath;

  factory WsMemberMoveAlbumPhotoRes.fromJson(Map<String, dynamic> json) =>
      _$WsMemberMoveAlbumPhotoResFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberMoveAlbumPhotoResToJson(this);
}
