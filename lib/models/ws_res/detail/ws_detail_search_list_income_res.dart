import 'package:frechat/models/ws_res/detail/ws_detail_search_list_coin_res.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_detail_search_list_income_res.g.dart';

@JsonSerializable()
class WsDetailSearchListIncomeRes {
  WsDetailSearchListIncomeRes({
    this.pageNumber,
    this.totalPages,
    this.fullListSize,
    this.pageSize,
    this.list,
  });

  factory WsDetailSearchListIncomeRes.create({num? pageNumber, num? totalPages, num? fullListSize, num? pageSize, List<DetailListInfo>? list}) {
    return WsDetailSearchListIncomeRes(
      pageNumber: pageNumber,
      totalPages: totalPages,
      fullListSize: fullListSize,
      pageSize: pageSize,
      list: list,
    );
  }

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

  /// list
  @JsonKey(name: 'list')
  List<DetailListInfo>? list;

  factory WsDetailSearchListIncomeRes.fromJson(Map<String, dynamic> json) => _$WsDetailSearchListIncomeResFromJson(json);
  Map<String, dynamic> toJson() => _$WsDetailSearchListIncomeResToJson(this);
}