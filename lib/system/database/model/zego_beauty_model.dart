
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zyg_sqflite_plugin/zyg_sqflite_plugin.dart';

class ZegoBeautyModel extends SQFLiteHandler implements SQFLiteBaseTable {
  final ProviderRef? ref;
  final num? beautyTypeIndex;
  final num? currentValue;

  ZegoBeautyModel({
    this.ref,
    this.beautyTypeIndex,
    this.currentValue,
  });

  @override
  String get createTableSql => SQFLiteDDLUtil.create(model: ZegoBeautyModel(ref: ref));

  @override
  String get tableName => 'ZegoBeautyModel';

  @override
  List<SQFLiteColumnModel> get columns => [
    SQFLiteColumnModel(name: 'beautyTypeIndex', type: num, isPrimaryKey: true),
    SQFLiteColumnModel(name: 'currentValue', type: num),
  ];
  @override
  Map<String, dynamic> toMap() {
    return {
      'beautyTypeIndex': beautyTypeIndex,
      'currentValue': currentValue,
    };
  }

  factory ZegoBeautyModel.fromJson(Map<String, dynamic> jsonData) {
    return ZegoBeautyModel(
      beautyTypeIndex: jsonData['beautyTypeIndex'] as num?,
      currentValue: jsonData['currentValue'] as num?,
    );
  }

  static String encode(ZegoBeautyModel zegoBeautyModel) =>
      json.encode(zegoBeautyModel.toMap());

  static List<ZegoBeautyModel> decode(List<Map<String, dynamic>> zegoBeautyModel) {
    return zegoBeautyModel.map<ZegoBeautyModel>((item) {
      return ZegoBeautyModel.fromJson(item);
    }).toList();
  }
}
