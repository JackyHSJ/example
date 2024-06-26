// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_member_move_album_photo_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsMemberMoveAlbumPhotoRes _$WsMemberMoveAlbumPhotoResFromJson(Map<String, dynamic> json) =>
    WsMemberMoveAlbumPhotoRes(
      albumsPath: (json['albumsPath'] as List).map((album) => AlbumsPathInfo.fromJson(album)).toList(),
    );

Map<String, dynamic> _$WsMemberMoveAlbumPhotoResToJson(WsMemberMoveAlbumPhotoRes instance) =>
    <String, dynamic>{
      'albumsPath': instance.albumsPath,
    };
