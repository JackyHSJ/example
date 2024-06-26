import 'package:frechat/models/ws_res/member/ws_member_fate_recommend_res.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_member_fate_online_res.g.dart';

@JsonSerializable()
class WsMemberFateOnlineRes {
  WsMemberFateOnlineRes({
    this.pageNumber,
    this.totalPages,
    this.fullListSize,
    this.pageSize,
    this.list,
    this.topList,
    this.orderSeq,
    this.topListPage
  });

  /// 當前頁數
  @JsonKey(name: 'pageNumber')
  num? pageNumber;

  /// 總頁數
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
  
  factory WsMemberFateOnlineRes.fromJson(Map<String, dynamic> json) =>
      _$WsMemberFateOnlineResFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberFateOnlineResToJson(this);
}


