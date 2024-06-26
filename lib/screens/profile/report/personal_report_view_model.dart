
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:frechat/screens/profile/report/law/personal_report_law.dart';
import 'package:frechat/system/constant/law.dart';

import '../../../models/profile/personal_cell_model.dart';
import '../../../models/profile/personal_report_model.dart';
import '../../../widgets/theme/original/app_colors.dart';

class PersonalReportViewModel {
  List<PersonalReportModel> reportList = [
    PersonalReportModel(title: '封禁總人數', reportNum: 2845, backGroundColor: AppColors.mainPink),
    PersonalReportModel(title: '帳號封禁', reportNum: 1989, backGroundColor: AppColors.mainPurple),
    PersonalReportModel(title: 'IP 封禁', reportNum: 885, backGroundColor: AppColors.mainYellow),
    PersonalReportModel(title: '設備封禁', reportNum: 1062, backGroundColor: AppColors.mainBlue),
  ];

  List<PersonalReportCellModel> reportUserList = [
    PersonalReportCellModel(userId: '1000000', nickName: '為夢想努力澆熱水', reportReason: '10年 廣告引流'),
    PersonalReportCellModel(userId: '1000004', nickName: '小哥哥艾里', reportReason: '10年 色情違規'),
    PersonalReportCellModel(userId: '1000009', nickName: '三重成吉思汗', reportReason: '10年 違反平台規定'),
    PersonalReportCellModel(userId: '1000007', nickName: '印度成吉思汗', reportReason: '10年 廣告引流'),
    PersonalReportCellModel(userId: '1000003', nickName: '踢歐歪利', reportReason: '10年 廣告引流'),
    PersonalReportCellModel(userId: '1000000', nickName: 'YYDS', reportReason: '10年 色情違規'),
    PersonalReportCellModel(userId: '1000000', nickName: '為夢想努力澆熱水', reportReason: '10年 廣告引流'),
    PersonalReportCellModel(userId: '1000004', nickName: '小哥哥艾里', reportReason: '10年 色情違規'),
    PersonalReportCellModel(userId: '1000009', nickName: '三重成吉思汗', reportReason: '10年 違反平台規定'),
    PersonalReportCellModel(userId: '1000007', nickName: '印度成吉思汗', reportReason: '10年 廣告引流'),
    PersonalReportCellModel(userId: '1000003', nickName: '踢歐歪利', reportReason: '10年 廣告引流'),
    PersonalReportCellModel(userId: '1000000', nickName: 'YYDS', reportReason: '10年 色情違規'),
    PersonalReportCellModel(userId: '1000000', nickName: '為夢想努力澆熱水', reportReason: '10年 廣告引流'),
    PersonalReportCellModel(userId: '1000004', nickName: '小哥哥艾里', reportReason: '10年 色情違規'),
    PersonalReportCellModel(userId: '1000009', nickName: '三重成吉思汗', reportReason: '10年 違反平台規定'),
    PersonalReportCellModel(userId: '1000007', nickName: '印度成吉思汗', reportReason: '10年 廣告引流'),
    PersonalReportCellModel(userId: '1000003', nickName: '踢歐歪利', reportReason: '10年 廣告引流'),
    PersonalReportCellModel(userId: '1000000', nickName: 'YYDS', reportReason: '10年 色情違規'),
  ];

  List<PersonalCellModel> cellList = [
    PersonalCellModel(title: '用戶行為管理規範', icon: 'assets/profile/profile_block_icon_1.png', des: '', remark: [Law.blockUserActLaw]),
    PersonalCellModel(title: '未成年人健康管理規範', icon: 'assets/profile/profile_block_icon_2.png', des: '', remark: [Law.blockTeenHealthLaw]),
    PersonalCellModel(title: '聊天管理規範', icon: 'assets/profile/profile_block_icon_3.png', des: '', remark: [Law.blockChatManageLaw]),
    // PersonalCellModel(title: '平台規範公約', icon: Icon(Icons.message_outlined), remark: ['123']),
    // PersonalCellModel(title: '防網路詐騙公告', icon: Icon(Icons.message_outlined), remark: ['123']),
  ];

  List<PersonalCellModel> swiperList = [
    PersonalCellModel(title: '平台规范公约', icon: 'assets/profile/profile_swiper_1.png', remark: [Law.blockPlatformLawSwiper]),
    PersonalCellModel(title: '防网络诈骗公告', icon: 'assets/profile/profile_swiper_1.png', remark: [Law.blockTeenHealthLaw]),
  ];

  late SwiperController swiperController;

  init() {
    swiperController = SwiperController();
  }

  dispose() {
    swiperController.dispose();
  }
}