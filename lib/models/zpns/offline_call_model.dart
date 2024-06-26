

import 'dart:convert';

import 'package:frechat/models/zpns/offline_call_zego_info_model.dart';

class OfflineCallExtrasModel {
  /// 通道名稱，用於識別消息的分類或來源
  final String? channelName;

  /// 通道描述，提供關於通道用途的額外信息
  final String? channelDescription;

  /// 通道權限，可能表示用戶在該通道中的權限等級
  final String? channelPerm;

  /// 統計信息，可能是加密的，包含有關消息或通道的統計數據
  final String? nStatsExpose;

  /// 權限狀態，可能表示該消息的權限設置（如公開、私有）
  final String? rightsStat;

  /// 消息來源的主機名
  final String? sourceHost;

  /// 通道重要性，可能用於控制通知的優先級
  final String? channelImportance;

  /// Zego 相關信息，可能是與 Zego 服務相關的配置或標識符
  final OfflineCallZegoInfo? zego;

  /// 分區優先級，用於消息分區的優先級分類
  final String? sectionPrrCl;

  /// 通知優先級，可能用於控制通知的顯示優先級
  final String? notificationPriority;

  /// 超時設置，可能表示消息的有效時間或過期時間
  final String? timeout;

  /// 是否使用點擊活動，可能表示點擊通知後的行為
  final String? useClickedActivity;

  /// 目標名稱，可能是消息接收方的標識符或名稱
  final String? targetName;

  /// 前端時間戳，可能表示消息生成的時間
  final String? feTs;

  /// 載荷，通常是消息的主體內容
  final String? payload;

  /// 通知效果，可能用於控制通知的表現形式（如聲音、震動）
  final String? notifyEffect;

  /// 消息時間戳，可能是消息發送的時間
  final String? mTs;

  /// 通道類型，可能用於區分不同類型的通道或消息
  final String? channelType;

  /// 通道 ID，唯一標識一個通道
  final String? channelId;

  /// 消息來源的環境，可能用於區分不同的服務或部署環境
  final String? sourceEnvironment;

  OfflineCallExtrasModel({
    this.channelName,
    this.channelDescription,
    this.channelPerm,
    this.nStatsExpose,
    this.rightsStat,
    this.sourceHost,
    this.channelImportance,
    this.zego,
    this.sectionPrrCl,
    this.notificationPriority,
    this.timeout,
    this.useClickedActivity,
    this.targetName,
    this.feTs,
    this.payload,
    this.notifyEffect,
    this.mTs,
    this.channelType,
    this.channelId,
    this.sourceEnvironment,
  });

  factory OfflineCallExtrasModel.fromJson(Map<String, dynamic> jsonObj) {
    final zegoInfoJsonObj = json.decode(jsonObj['zego']);
    return OfflineCallExtrasModel(
      channelName: jsonObj['channel_name'],
      channelDescription: jsonObj['channel_description'],
      channelPerm: jsonObj['channel_perm'],
      nStatsExpose: jsonObj['n_stats_expose'],
      rightsStat: jsonObj['rights_stat'],
      sourceHost: jsonObj['_source_host_'],
      channelImportance: jsonObj['channel_importance'],
      zego: jsonObj['zego'] == null ? OfflineCallZegoInfo() : OfflineCallZegoInfo.fromJson(zegoInfoJsonObj),
      sectionPrrCl: jsonObj['section_prr_cl'],
      notificationPriority: jsonObj['notification_priority'],
      timeout: jsonObj['timeout'],
      useClickedActivity: jsonObj['use_clicked_activity'].toString(),
      targetName: jsonObj['__target_name'],
      feTs: jsonObj['fe_ts'],
      payload: jsonObj['payload'],
      notifyEffect: jsonObj['notify_effect'],
      mTs: jsonObj['__m_ts'],
      channelType: jsonObj['channel_type'],
      channelId: jsonObj['channel_id'],
      sourceEnvironment: jsonObj['_source_environment_'],
    );
  }
}
