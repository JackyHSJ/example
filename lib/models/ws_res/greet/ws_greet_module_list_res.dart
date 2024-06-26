
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:frechat/system/extension/json.dart';

part 'ws_greet_module_list_res.g.dart';

@JsonSerializable()
class WsGreetModuleListRes {
  WsGreetModuleListRes({
    this.list
  });

  /// 相簿資料
  @JsonKey(name: 'list')
  List<GreetModuleInfo>? list;

  factory WsGreetModuleListRes.fromJson(Map<String, dynamic> json) =>
      _$WsGreetModuleListResFromJson(json);
  Map<String, dynamic> toJson() => _$WsGreetModuleListResToJson(this);

  WsGreetModuleListRes copyWith({
    List<GreetModuleInfo>? list,
  }) {
    return WsGreetModuleListRes(
      list: list ?? this.list,
    );
  }
}

@JsonSerializable()
class GreetModuleInfo {
  GreetModuleInfo({
    this.createTime,
    this.updateTime,
    this.id,
    this.modelName,
    this.greetingText,
    this.greetingPic,
    this.greetingAudio,
    this.status,
    this.userId,
});

  /// 新增時間
  @JsonKey(name: 'createTime')
  num? createTime;

  /// 新增時間
  @JsonKey(name: 'updateTime')
  num? updateTime;

  /// 模板id
  @JsonKey(name: 'id')
  num? id;

  /// 模板備註
  @JsonKey(name: 'modelName')
  String? modelName;

  /// 招呼語-文字
  @JsonKey(name: 'greetingText')
  String? greetingText;

  /// 招呼語-照片
  @JsonKey(name: 'greetingPic')
  String? greetingPic;

  /// 招呼語-語音
  @JsonKey(name: 'greetingAudio')
  GreetModuleInfoAudio? greetingAudio;

  /// 狀態 0:未使用 1:使用中 2:審核中 3:審核失敗
  @JsonKey(name: 'status')
  num? status;

  /// 新增時間
  @JsonKey(name: 'userId')
  num? userId;

  factory GreetModuleInfo.fromJson(Map<String, dynamic> jsonObj) {
    if(jsonObj['greetingAudio'] !=null){
      Map<String,dynamic> audioJson = json.tryDecode(jsonObj['greetingAudio']);
      print(audioJson);
      jsonObj['greetingAudio'] = GreetModuleInfoAudio.fromJson(audioJson);
    }
    print(jsonObj);
    return _$GreetModuleInfoFromJson(jsonObj);
  }


  Map<String, dynamic> toJson() => _$GreetModuleInfoToJson(this);

  GreetModuleInfo copyWith({
    num? createTime,
    num? updateTime,
    num? id,
    String? modelName,
    String? greetingText,
    String? greetingPic,
    GreetModuleInfoAudio? greetingAudio,
    num? status,
    num? userId,
  }) {
    return GreetModuleInfo(
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
      id: id ?? this.id,
      modelName: modelName ?? this.modelName,
      greetingText: greetingText ?? this.greetingText,
      greetingPic: greetingPic ?? this.greetingPic,
      greetingAudio: greetingAudio ?? this.greetingAudio,
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }
}


@JsonSerializable()
class GreetModuleInfoAudio {
  GreetModuleInfoAudio({
    this.filePath,
    this.length
  });

  /// 招呼語-照片
  @JsonKey(name: 'filePath')
  String? filePath;

  /// 招呼語-語音時長
  @JsonKey(name: 'length')
  num? length;

  factory GreetModuleInfoAudio.fromJson(Map<String, dynamic> json) =>
      _$GreetModuleInfoAudioFromJson(json);
  Map<String, dynamic> toJson() => _$GreetModuleInfoAudioToJson(this);

  GreetModuleInfoAudio copyWith({
    List<GreetModuleInfoAudio>? list,
  }) {
    return GreetModuleInfoAudio(
      filePath: filePath ?? this.filePath,
      length: length ?? this.length,
    );
  }
}
