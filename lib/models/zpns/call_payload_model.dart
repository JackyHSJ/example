

class CallPayloadModel {
  CallPayloadModel({
    required this.callerName,
    required this.callerAvatar,
    required this.callWithVoiceOrVideo,
    required this.callType,
    required this.timeout,
    required this.age,
    required this.gender,
});
  String callerName;
  String callerAvatar;
  num callWithVoiceOrVideo;
  num callType;
  num timeout;
  num age;
  num gender;

  factory CallPayloadModel.fromJson(Map<String, dynamic> json) {
    return CallPayloadModel(
      callerName: json['callerName'],
      callerAvatar: json['callerAvatar'],
      callWithVoiceOrVideo: json['callWithVoiceOrVideo'],
      callType: json['callType'],
      timeout: json['timeout'],
      age: json['age'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'callerName': callerName,
      'callerAvatar': callerAvatar,
      'callWithVoiceOrVideo': callWithVoiceOrVideo,
      'callType': callType,
      'timeout': timeout,
      'age': age,
      'gender': gender,
    };
  }
}