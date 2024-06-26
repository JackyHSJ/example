

import 'dart:convert';

class OpenInstallModel {
  OpenInstallModel({
    required this.channelCode,
    required this.bindData,
    this.shouldRetry,
  });
  String channelCode;
  BindDataInfo bindData;
  bool? shouldRetry;

  factory OpenInstallModel.fromJson(Map<String, dynamic> jsonData) {
    final jsonObj = json.decode(jsonData['bindData']);
    return OpenInstallModel(
      channelCode: jsonData['channelCode'] as String,
      bindData: jsonData['bindData'] == '' ? BindDataInfo() : BindDataInfo.decode(jsonObj),
      shouldRetry: jsonData['shouldRetry'] as bool?,
    );
  }

  static OpenInstallModel decode(Map<String, dynamic> openInstallModel) {
    return OpenInstallModel.fromJson(openInstallModel);
  }
}

class BindDataInfo {
  BindDataInfo({
    this.inviteCode,
  });
  String? inviteCode;

  factory BindDataInfo.fromJson(Map<String, dynamic> jsonData) {
    return BindDataInfo(
      inviteCode: jsonData['InviteCode'] as String?,
    );
  }

  static BindDataInfo decode(Map<String, dynamic> bindDataInfo) {
    return BindDataInfo.fromJson(bindDataInfo);
  }
}