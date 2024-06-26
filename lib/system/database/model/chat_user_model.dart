import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_strike_up_res.dart';
import 'package:zyg_sqflite_plugin/zyg_sqflite_plugin.dart';

class ChatUserModel extends SQFLiteHandler implements SQFLiteBaseTable {
  final ProviderRef? ref;
  final num? userId;
  final String? roomIcon;
  final num? cohesionLevel;
  final num? userCount;
  final num? isOnline;
  final String? userName;
  final num? roomId;
  final String? roomName;
  final num? points;
  final String? remark;
  final num? unRead;
  final String? recentlyMessage;
  final num? pinTop;
  final num? timeStamp;
  final String? charmCharge;
  final num? notificationFlag;
  /// 訊息的狀態：0(傳送中)，1(傳送成功)，2(傳送失敗)
  final num? sendStatus;

  ChatUserModel({
    this.ref,
    this.userId,
    this.roomIcon,
    this.cohesionLevel,
    this.userCount,
    this.isOnline,
    this.userName,
    this.roomId,
    this.roomName,
    this.points,
    this.remark,
    this.unRead,
    this.recentlyMessage,
    this.pinTop,
    this.timeStamp,
    this.charmCharge,
    this.notificationFlag,
    this.sendStatus,
  });

  @override
  int get databaseVersion => 2;

  @override
  String get createTableSql =>
      SQFLiteDDLUtil.create(model: ChatUserModel(ref: ref));

  @override
  String get tableName => 'ChatUserModel';

  @override
  List<SQFLiteColumnModel> get columns => [
        SQFLiteColumnModel(name: 'userId', type: num, isPrimaryKey: true),
        SQFLiteColumnModel(name: 'roomIcon', type: String),
        SQFLiteColumnModel(name: 'cohesionLevel', type: num),
        SQFLiteColumnModel(name: 'userCount', type: num),
        SQFLiteColumnModel(name: 'isOnline', type: num),
        SQFLiteColumnModel(name: 'userName', type: String, isPrimaryKey: true),
        SQFLiteColumnModel(name: 'roomId', type: num),
        SQFLiteColumnModel(name: 'roomName', type: String),
        SQFLiteColumnModel(name: 'points', type: num),
        SQFLiteColumnModel(name: 'remark', type: String),
        SQFLiteColumnModel(name: 'unRead', type: num),
        SQFLiteColumnModel(name: 'recentlyMessage', type: String),
        SQFLiteColumnModel(name: 'pinTop', type: num),
        SQFLiteColumnModel(name: 'timeStamp', type: num),
        SQFLiteColumnModel(name: 'charmCharge', type: String),
        SQFLiteColumnModel(name: 'notificationFlag', type: num),
        SQFLiteColumnModel(name: 'sendStatus', type: num),

  ];
  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'roomIcon': roomIcon,
      'cohesionLevel': cohesionLevel,
      'userCount': userCount,
      'isOnline': isOnline,
      'userName': userName,
      'roomId': roomId,
      'roomName': roomName,
      'points': points,
      'remark': remark,
      'unRead': unRead,
      'recentlyMessage': recentlyMessage,
      'pinTop': pinTop,
      'timeStamp': timeStamp,
      'charmCharge': charmCharge,
      'notificationFlag': notificationFlag,
      'sendStatus':sendStatus,
    };
  }

  factory ChatUserModel.fromJson(Map<String, dynamic> jsonData) {
    return ChatUserModel(
      userId: jsonData['userId'] as num?,
      roomIcon: jsonData['roomIcon'] as String?,
      cohesionLevel: jsonData['cohesionLevel'] as num?,
      userCount: jsonData['userCount'] as num?,
      isOnline: jsonData['isOnline'] as num?,
      userName: jsonData['userName'] as String?,
      roomId: jsonData['roomId'] as num?,
      roomName: jsonData['roomName'] as String?,
      points: jsonData['points'] as num?,
      remark: jsonData['remark'] as String?,
      unRead: jsonData['unRead'] as num?,
      recentlyMessage: jsonData['recentlyMessage'] as String?,
      pinTop: jsonData['pinTop'] as num?,
      timeStamp: jsonData['timeStamp'] as num?,
      charmCharge: jsonData['charmCharge'] as String?,
      notificationFlag: jsonData['notificationFlag'] as num?,
      sendStatus: jsonData['sendStatus'] as num?,
    );
  }

  factory ChatUserModel.fromWsModel(
      ChatRoomInfo chatRoomInfo, SearchListInfo searchListInfo) {
    return ChatUserModel(
      userId: chatRoomInfo.userId,
      roomIcon: chatRoomInfo.roomIcon,
      cohesionLevel: chatRoomInfo.cohesionLevel,
      userCount: chatRoomInfo.userCount,
      isOnline: searchListInfo.isOnline,
      userName: chatRoomInfo.userName,
      roomId: chatRoomInfo.roomId,
      roomName: chatRoomInfo.roomName,
      points: chatRoomInfo.points,
      remark: searchListInfo.remark,
      unRead: 1,
      recentlyMessage: '',
      pinTop: 0,
      timeStamp: DateTime.now().millisecondsSinceEpoch,
      notificationFlag: searchListInfo.notificationFlag,
      sendStatus: searchListInfo.sendStatus ?? 1,
    );
  }

  factory ChatUserModel.fromStikeUpModel(
      ChatRoomInfo chatRoomInfo) {
    return ChatUserModel(
      userId: chatRoomInfo.userId,
      roomIcon: chatRoomInfo.roomIcon,
      cohesionLevel: chatRoomInfo.cohesionLevel,
      userCount: chatRoomInfo.userCount,
      isOnline: chatRoomInfo.isOnline,
      userName: chatRoomInfo.userName,
      roomId: chatRoomInfo.roomId,
      roomName: chatRoomInfo.roomName,
      points: chatRoomInfo.points,
      remark: chatRoomInfo.remark,
      unRead: 0,
      recentlyMessage: '',
      pinTop: 0,
      timeStamp: DateTime.now().millisecondsSinceEpoch,
      notificationFlag: chatRoomInfo.notificationFlag,
      sendStatus: 1,
    );
  }

  static String encode(ChatUserModel chatUserModel) =>
      json.encode(ChatUserModel().toMap());

  static List<ChatUserModel> decode(List<Map<String, dynamic>> chatUserModel) {
    return chatUserModel.map<ChatUserModel>((item) {
      return ChatUserModel.fromJson(item);
    }).toList();
  }

  ChatUserModel copyWith({
    ProviderRef? ref,
    num? userId,
    String? roomIcon,
    num? cohesionLevel,
    num? userCount,
    num? isOnline,
    String? userName,
    num? roomId,
    String? roomName,
    num? points,
    String? remark,
    num? unRead,
    String? recentlyMessage,
    num? pinTop,
    num? timeStamp,
    String? charmCharge,
    num? notificationFlag,
    num? sendStatus ,

  }) {
    return ChatUserModel(
      ref: ref ?? this.ref,
      userId: userId ?? this.userId,
      roomIcon: roomIcon ?? this.roomIcon,
      cohesionLevel: cohesionLevel ?? this.cohesionLevel,
      userCount: userCount ?? this.userCount,
      isOnline: isOnline ?? this.isOnline,
      userName: userName ?? this.userName,
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      points: points ?? this.points,
      remark: remark ?? this.remark,
      unRead: unRead ?? this.unRead,
      recentlyMessage: recentlyMessage ?? this.recentlyMessage,
      pinTop: pinTop ?? this.pinTop,
      timeStamp: timeStamp ?? this.timeStamp,
      charmCharge: charmCharge ?? this.charmCharge,
      notificationFlag: notificationFlag ?? this.notificationFlag,
      sendStatus: sendStatus?? this.sendStatus,
    );
  }
}
