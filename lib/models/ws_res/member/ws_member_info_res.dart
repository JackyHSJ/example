import 'package:json_annotation/json_annotation.dart';

part 'ws_member_info_res.g.dart';

@JsonSerializable()
class WsMemberInfoRes {
  WsMemberInfoRes({
    this.userName,
    this.agentName,
    this.hometown,
    this.occupation,
    this.annualIncome,
    this.education,
    this.gender,
    this.age,
    this.maritalStatus,
    this.weight,
    this.height,
    this.selfIntroduction,
    this.location,
    this.updateTime,
    this.album,
    this.albumsPath,
    this.avatarAuth,
    this.avatar,
    this.avatarPath,
    this.audioAuth,
    this.audio,
    this.audioPath,
    this.nickNameAuth,
    this.nickName,
    this.realNameAuth,
    this.charmLevel,
    this.isFollow,
    this.realPersonAuth,
    this.tag,
    this.charmCharge,
    this.tvStatus,
    this.isOnline,
    this.regTime,
    this.agentLevel,
    this.charmPoints,
    this.osType,
    this.lockStatus,
    this.parent,
    this.type,
  });

  /// 用戶id
  @JsonKey(name: 'userName')
  String? userName;

  /// 推廣id
  @JsonKey(name: 'agentName')
  String? agentName;

  /// 家鄉
  @JsonKey(name: 'hometown')
  String? hometown;

  /// 職業
  @JsonKey(name: 'occupation')
  String? occupation;

  /// 年收入
  @JsonKey(name: 'annualIncome')
  String? annualIncome;

  /// 教育
  @JsonKey(name: 'education')
  String? education;

  /// 性别(0:女生,1:男生)
  @JsonKey(name: 'gender')
  num? gender;

  /// 年齡
  @JsonKey(name: 'age')
  num? age;

  /// 婚姻狀態 0:單身 1:已婚 2:寻爱中 3:有伴侣 4:离异
  @JsonKey(name: 'maritalStatus')
  num? maritalStatus;

  /// 體重
  @JsonKey(name: 'weight')
  num? weight;

  /// 身高
  @JsonKey(name: 'height')
  num? height;

  /// 自我介绍
  @JsonKey(name: 'selfIntroduction')
  String? selfIntroduction;

  /// 所在地
  @JsonKey(name: 'location')
  String? location;

  /// 更新時間
  @JsonKey(name: 'updateTime')
  int? updateTime;

  /// 相簿
  @JsonKey(name: 'album')
  String? album;

  /// 相簿地址
  @JsonKey(name: 'albumsPath')
  List<AlbumsPathInfo>? albumsPath;

  /// 頭像認證 0:未認證 1:已認證 2:認證中 3:認證失敗 4:已認證重新送審中
  @JsonKey(name: 'avatarAuth')
  num? avatarAuth;

  /// 頭像
  @JsonKey(name: 'avatar')
  String? avatar;

  /// 頭像地址
  @JsonKey(name: 'avatarPath')
  String? avatarPath;

  /// 聲音展示認證 0:未認證 1:已認證 2:認證中 3:認證失敗 4:已認證重新送審中
  @JsonKey(name: 'audioAuth')
  num? audioAuth;

  /// 聲音展示
  @JsonKey(name: 'audio')
  num? audio;

  /// 聲音展示地址
  @JsonKey(name: 'audioPath')
  String? audioPath;

  /// 暱稱認證 0:未認證 1:已認證 2:認證中 3:認證失敗 4:已認證重新送審中
  @JsonKey(name: 'nickNameAuth')
  num? nickNameAuth;

  /// 暱稱
  @JsonKey(name: 'nickName')
  String? nickName;

  /// 实名认证
  @JsonKey(name: 'realNameAuth')
  num? realNameAuth;

  /// 真人认证
  @JsonKey(name: 'realPersonAuth')
  num? realPersonAuth;

  /// 魅力值等級(1,2,3,4...)
  @JsonKey(name: 'charmLevel')
  num? charmLevel;

  /// 魅力值
  @JsonKey(name: 'charmPoints')
  num? charmPoints;

  /// 是否关注
  @JsonKey(name: 'isFollow')
  bool? isFollow;

  @JsonKey(name: 'tag')
  String? tag;

  /// 信息｜語音｜視頻　收費價格
  @JsonKey(name: 'charmCharge')
  String? charmCharge;

  /// 1:匿名 2:不匿名
  @JsonKey(name: 'tvStatus')
  num? tvStatus;

  /// 在線狀態(0:離線 ,1:在線)
  @JsonKey(name: 'isOnline')
  num? isOnline;

  /// 註冊時間
  @JsonKey(name: 'regTime')
  dynamic regTime;

  /// 推廣等級
  @JsonKey(name: 'agentLevel')
  num? agentLevel;

  /// 手機系統
  @JsonKey(name: 'osType')
  num? osType;

  /// 封号状态(0:无,1:短期,2:永久)
  @JsonKey(name: 'lockStatus')
  num? lockStatus;

  /// 上級
  @JsonKey(name: 'parent')
  num? parent;

  /// 帐号类型(0:一般用户, 1:推广, 2:审核帐号)
  @JsonKey(name: 'type')
  num? type;

  factory WsMemberInfoRes.fromJson(Map<String, dynamic> json) =>
      _$WsMemberInfoResFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberInfoResToJson(this);
}

@JsonSerializable()
class AlbumsPathInfo {
  AlbumsPathInfo({
    this.id,
    this.status,
    this.filePath,
    this.fileType,
  });

  /// 檔案id
  @JsonKey(name: 'id')
  num? id;

  /// 狀態：相簿認證 0:未認證 1:已認證 2:認證中 3:認證失敗 4:已認證重新送審中
  @JsonKey(name: 'status')
  num? status;

  /// 相簿地址
  @JsonKey(name: 'filePath')
  String? filePath;

  /// 檔案分類 1:玩家頭像 2:真人认证 3:相册
  /// 4:招呼語(4:照片、5:語音、6:文字) 7:暱稱
  /// 8:舉報-用戶 9:舉報-動態 10:聲音展示
  /// 11:彈窗banner 12:禮物
  @JsonKey(name: 'fileType')
  String? fileType;

  factory AlbumsPathInfo.fromJson(Map<String, dynamic> json) =>
      _$AlbumsPathInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumsPathInfoToJson(this);
}