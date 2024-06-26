// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_member_move_album_photo_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsMemberMoveAlbumPhotoReq _$WsMemberMoveAlbumPhotoReqFromJson(Map<String, dynamic> json) =>
    WsMemberMoveAlbumPhotoReq(
      albumsPath: (json['albumsPath'] as List).map((album) => AlbumsPathInfo.fromJson(album)).toList(),
    );

Map<String, dynamic> _$WsMemberMoveAlbumPhotoReqToJson(WsMemberMoveAlbumPhotoReq instance) =>
    <String, dynamic>{
      'albumsPath': instance.albumsPath,
    };
