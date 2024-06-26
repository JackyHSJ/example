
import 'package:frechat/models/res/member_register_res.dart';

class AnalyticsRegister {
  AnalyticsRegister({
    this.userId,
    this.tId,
    this.userName,
    this.nickName,
    this.benefit,
    this.riskDescription,
  });

  final String? userName;
  final num? userId;
  final String? nickName;
  final String? tId;
  final RegisterBenefit? benefit;
  final String? riskDescription;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'tId': tId,
      'userName': userName,
      'nickName': nickName,
      'benefit': benefit?.toJson(),
      'riskDescription': riskDescription,
    };
  }

  factory AnalyticsRegister.fromJson(Map<String, dynamic> map) {
    return AnalyticsRegister(
      userId: map['userId'] as num?,
      tId: map['tId'] as String?,
      userName: map['userName'] as String?,
      nickName: map['nickName'] as String?,
      benefit: RegisterBenefit.fromJson(map['benefit']),
      riskDescription: map['riskDescription'] as String?,
    );
  }
}