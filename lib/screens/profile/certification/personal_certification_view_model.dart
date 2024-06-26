// [Dep] By Neo
//
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:frechat/models/certification_model.dart';
// import 'package:frechat/models/profile/personal_certification_btn_model.dart';
// import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
// import 'package:frechat/models/ws_req/member/ws_member_real_person_veri_req.dart';
// import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
// import 'package:frechat/models/ws_res/member/ws_member_real_person_veri_res.dart';
// import 'package:frechat/system/base_view_model.dart';
// import 'package:frechat/system/call_back_function.dart';
// import 'package:frechat/system/constant/enum.dart';
// import 'package:frechat/system/provider/user_info_provider.dart';
// import 'package:frechat/system/providers.dart';
// import 'package:frechat/system/repository/response_code.dart';
// import 'package:frechat/system/ws_comm/ws_member.dart';
//
// class PersonalCertificationViewModel {
//   PersonalCertificationViewModel();
//
//   CertificationType? realPersonAuthType;
//
//   init() {
//
//   }
//
//   dispose() {
//
//   }
//
//   PersonalCertificationBtnModel getCertificationBtnModel(num authType) {
//     final type = CertificationModel.getType(authNum: authType);
//
//     String btnTitle = '';
//     bool? authenticating;
//     bool? alreadyCertification;
//     switch (type) {
//       case CertificationType.fail:
//         btnTitle = '重新認證';
//         alreadyCertification = false;
//       case CertificationType.processing:
//         btnTitle = '認證中';
//         authenticating = true;
//       case CertificationType.done:
//         btnTitle = '已認證';
//         alreadyCertification = true;
//       case CertificationType.not:
//         btnTitle = '未認證';
//         alreadyCertification = false;
//       default:
//         btnTitle = '未認證';
//         alreadyCertification = false;
//     }
//
//     return PersonalCertificationBtnModel(
//         btnTitle: btnTitle,
//         authenticating: authenticating,
//         alreadyCertification: alreadyCertification,
//     );
//   }
// }