import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/util/date_format_util.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_res.g.dart';

@JsonSerializable()
class BaseRes {
  BaseRes({
    required this.resultCode,
    this.msg,
    this.resultMap,
    this.resultMsg,
    this.f,
    this.uuId,
    this.createTime,
    this.content,
    this.contentType,
  });

  @JsonKey(name: 'resultCode')
  final String resultCode;

  @JsonKey(name: 'msg')
  final String? msg;

  @JsonKey(name: 'resultMap')
  final dynamic resultMap;

  @JsonKey(name: 'resultMsg')
  final dynamic resultMsg;

  @JsonKey(name: 'f')
  final String? f;

  /// 随机码
  @JsonKey(name: 'uuId')
  final String? uuId;

  /// 发话时间
  @JsonKey(name: 'createTime')
  final num? createTime;

  /// 发话内容
  @JsonKey(name: 'content')
  final dynamic content;

  @JsonKey(name: 'contentType')
  final num? contentType;

  factory BaseRes.fromJson(Map<String, dynamic> json) =>
      _$BaseResFromJson(json);
  Map<String, dynamic> toJson() => _$BaseResToJson(this);


  printLog() {
    debugPrint('=== printResponseLog: ${DateTime.now()} ===');
    debugPrint('resultCode:$resultCode');
    debugPrint('msg:$msg');
    debugPrint('resultMap:$resultMap');
    debugPrint('f:$f');
    final time = DateTime.now();
    final timeFormat = DateFormatUtil.getDateWith12HourFormat(time);
    debugPrint('current time:$timeFormat');
  }
}