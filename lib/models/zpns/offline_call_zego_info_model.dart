

class OfflineCallZegoInfo {
  final String? callId;
  final num? version;
  final String? zpnsRequestId;

  OfflineCallZegoInfo({
    this.callId,
    this.version,
    this.zpnsRequestId,
  });

  factory OfflineCallZegoInfo.fromJson(Map<String, dynamic> json) {
    return OfflineCallZegoInfo(
      callId: json['call_id'] as String?,
      version: json['version'] as num?,
      zpnsRequestId: json['zpns_request_id'] as String?,
    );
  }
}
