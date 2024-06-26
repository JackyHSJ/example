
class AnalyticsTrackView {
  AnalyticsTrackView({
    this.timestamp,
  });

  final num? timestamp;

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
    };
  }

  factory AnalyticsTrackView.fromJson(Map<String, dynamic> map) {
    return AnalyticsTrackView(
      timestamp: map['timestamp'] as num?,
    );
  }
}