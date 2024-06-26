import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_member_delete_album_photo_res.g.dart';

@JsonSerializable()
class WsMemberDeleteAlbumPhotoRes {
  WsMemberDeleteAlbumPhotoRes({
    this.albumsPath,
  });

  /// 相簿資料
  @JsonKey(name: 'albumsPath')
  List<AlbumsPathInfo>? albumsPath;

  factory WsMemberDeleteAlbumPhotoRes.fromJson(Map<String, dynamic> json) =>
      _$WsMemberDeleteAlbumPhotoResFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberDeleteAlbumPhotoResToJson(this);
}
