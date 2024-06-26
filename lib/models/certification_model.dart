
import 'package:frechat/system/constant/enum.dart';

/// 0:未認證 1:已認證 2:認證中 3:認證失敗 4:已認證重新送審中(旧版)
/// 初始状态：0, 通过：1, 审核中：2, 驳回：3, 重新送审：4, 未通过：5（新版）
class CertificationModel {
   static CertificationType getType({
    required num? authNum
  }) {
    switch(authNum) {
      case 0:
        return CertificationType.not;
      case 1:
        return CertificationType.done;
      case 2:
        return CertificationType.processing;
      case 3:
        return CertificationType.reject;
      case 4:
        return CertificationType.resend;
      case 5:
        return CertificationType.fail;
      default:
        return CertificationType.fail;
    }
  }

   static String toTitle({
     required num? authNum
   }) {
     switch(authNum) {
       case 0:
         return '';
       case 1:
         return '';
       case 2:
         return '审核中';
       case 3:
         return '驳回';
       case 4:
         return '审核中';
       case 5:
         return '未通过';
       default:
         return '请洽客服';
     }
   }

   static CertificationType getGreetType({
     required num authNum
   }) {
     switch(authNum) {
       case 0:
         return CertificationType.unUse;
       case 1:
         return CertificationType.using;
       case 2:
         return CertificationType.processing;
       case 3:
         return CertificationType.fail;
       default:
         return CertificationType.fail;
     }
   }

   static String toGreetTitle({
     required num authNum
   }) {
     switch(authNum) {
       case 0:
         return '未使用';
       case 1:
         return '使用中';
       case 2:
         return '审核中';
       case 3:
         return '审核失败';
       default:
         return '請洽客服';
     }
   }

   ///初始状态：0, 通过：1,4, 审核中：2, 驳回：3, 未通过：5
   static String toAudioTitle({
     required num authNum
   }) {
     switch(authNum) {
       case 0:
         return '';
       case 1:
         return '';
       case 2:
         return '审核中';
       case 3:
         return '驳回';
       case 4:
         return '审核中';
       case 5:
         return '未通过';
       default:
         return '请洽客服';
     }
   }
}