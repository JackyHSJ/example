


import 'package:frechat/models/certification_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/repository/response_code.dart';

class RealPersonNameAuthUtil {

  static needBothAuth(num gender, num realPersonAuth, num realNameAuth) {

    final bool isGirl = gender == 0;
    final CertificationType personAuthType = CertificationModel.getType(authNum: realPersonAuth);
    final CertificationType nameAuthType = CertificationModel.getType(authNum: realNameAuth);

    if (isGirl) {
      if (personAuthType != CertificationType.done) {
        // 真人認證
        return ResponseCode.CODE_REAL_PERSON_VERIFICATION_UNDER_REVIEW;
      } else if (nameAuthType != CertificationType.done) {
        // 實名認證
        return ResponseCode.CODE_REAL_NAME_UNDER_REVIEW;
      } else {
        // 都認證
        return ResponseCode.CODE_SUCCESS;
      }
    } else {
      return ResponseCode.CODE_SUCCESS;
    }
  }
}