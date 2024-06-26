// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_member_delete_album_photo_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsMemberDeleteAlbumPhotoRes _$WsMemberDeleteAlbumPhotoResFromJson(Map<String, dynamic> json) =>
    WsMemberDeleteAlbumPhotoRes(
      albumsPath: (json['albumsPath'] as List).map((album) => AlbumsPathInfo.fromJson(album)).toList(),
    );

Map<String, dynamic> _$WsMemberDeleteAlbumPhotoResToJson(WsMemberDeleteAlbumPhotoRes instance) =>
    <String, dynamic>{
      'albumsPath': instance.albumsPath,
    };