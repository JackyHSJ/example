import 'package:json_annotation/json_annotation.dart';

part 'ws_member_fate_recommend_res.g.dart';

@JsonSerializable()
class WsMemberFateRecommendRes {
  WsMemberFateRecommendRes({
    this.pageNumber,
    this.totalPages,
    this.fullListSize,
    this.pageSize,
    this.list,
    this.topList,
    this.orderSeq,
    this.topListPage,
  });

  /// 當前頁數
  @JsonKey(name: 'pageNumber')
  num? pageNumber;

  /// 新註冊的會員 總頁數
  @JsonKey(name: 'totalPages')
  num? totalPages;

  /// 總筆數
  @JsonKey(name: 'fullListSize')
  num? fullListSize;

  /// 每頁筆數
  @JsonKey(name: 'pageSize')
  num? pageSize;

  /// 教育
  @JsonKey(name: 'list')
  List<FateListInfo>? list;

  /// 新註冊的會員
  @JsonKey(name: 'topList')
  List<FateListInfo>? topList;

  /// 新註冊的會員
  @JsonKey(name: 'orderSeq')
  num? orderSeq;

  //
  @JsonKey(name: 'topListPage')
  num? topListPage;
  
  factory WsMemberFateRecommendRes.fromJson(Map<String, dynamic> json) =>
      _$WsMemberFateRecommendResFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberFateRecommendResToJson(this);

  WsMemberFateRecommendRes copyWith({
    num? pageNumber,
    num? totalPages,
    num? fullListSize,
    num? pageSize,
    List<FateListInfo>? list,
    List<FateListInfo>? topList,
    num? orderSeq,
    num? topListPage,
  }) {
    return WsMemberFateRecommendRes(
      pageNumber: pageNumber ?? this.pageNumber,
      totalPages: totalPages ?? this.totalPages,
      fullListSize: fullListSize ?? this.fullListSize,
      pageSize: pageSize ?? this.pageSize,
      list: list ?? this.list,
      topList: topList ?? this.topList,
      orderSeq: orderSeq ?? this.orderSeq,
      topListPage: topListPage ?? this.topListPage,
    );
  }
}

class FateListInfo {
  FateListInfo({
    this.id,
    this.age,
    this.occupation,
    this.nickName,
    this.userName,
    this.weight,
    this.height,
    this.selfIntroduction,
    this.isOnline,
    this.roomId,
    this.location,
    this.realPersonAuth,
    this.realNameAuth,
    this.avatar,
    this.gender,
    this.hometown
  });

  /// id
  @JsonKey(name: 'id')
  num? id;

  /// 年齡
  @JsonKey(name: 'age')
  num? age;

  /// 职业
  @JsonKey(name: 'occupation')
  String? occupation;

  /// 用戶名稱
  @JsonKey(name: 'userName')
  String? userName;

  /// 用户昵称
  @JsonKey(name: 'nickName')
  String? nickName;

  /// 体重
  @JsonKey(name: 'weight')
  num? weight;

  /// 身高
  @JsonKey(name: 'height')
  num? height;

  /// 教育
  @JsonKey(name: 'selfIntroduction')
  String? selfIntroduction;

  /// 在線狀態(0:離線 ,1:在線)
  @JsonKey(name: 'isOnline')
  int? isOnline;

  @JsonKey(name: 'roomId')
  num? roomId;

  @JsonKey(name: 'location')
  String? location;

  @JsonKey(name: 'realPersonAuth')
  num? realPersonAuth;

  @JsonKey(name: 'realNameAuth')
  num? realNameAuth;

  @JsonKey(name: 'avatar')
  String? avatar;

  @JsonKey(name: 'gender')
  num? gender;

  @JsonKey(name: 'hometown')
  String? hometown;

  factory FateListInfo.fromJson(Map<String, dynamic> json) =>
      _$FateListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$FateListInfoToJson(this);
}


