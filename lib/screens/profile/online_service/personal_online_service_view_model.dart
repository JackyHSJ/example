import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/customer_service_hour/ws_customer_service_hour_req.dart';
import 'package:frechat/models/ws_res/customer_service_hour/ws_customer_service_hour_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/constant/law.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../../models/profile/personal_online_service_model.dart';

class PersonalOnlineServiceViewModel {
  WidgetRef ref;
  BuildContext context;
  ViewChange? setState;
  PersonalOnlineServiceViewModel({required this.ref,required this.context,this.setState});

  List<PersonalOnlineServiceModel> cellList = [
    PersonalOnlineServiceModel(title: '认证规则', des: '根据国家设定，用户需要通过身分证进行实名认证。女神用户还需要额外进行人脸识别以确保照片的真实性'),
    PersonalOnlineServiceModel(title: '苹果无法登录', des: '检查网络是否有问题，可试着断开WIFI或开启关闭数据试一下'),
    //PersonalOnlineServiceModel(title: '动态审核', des: '發布動態平台會進行審核才可以進行展示，請勿發布違規內容（包括但不侷限於色情、暴力、社恐涉政內容）'),
    PersonalOnlineServiceModel(title: '如何举报', des: '若发现违规内容，平台欢迎并鼓励举报。在「用户详情页」、「更多」、「举报」即可。若能提供截图等可以大大提高效率哦'),

    // PersonalOnlineServiceModel(title: '充值中心', lawList: [Law.customService]),
    PersonalOnlineServiceModel(title: '平台准则', lawList: true),
  ];

  Future<WsCustomerServiceHourRes> loadCustomerServiceHour() async {
    WsCustomerServiceHourReq reqBody = WsCustomerServiceHourReq.create();
    final WsCustomerServiceHourRes res = await ref.read(customerServiceHoutWsProvider).wsCustomerServiceHoursWs(reqBody,
        onConnectSuccess: (succMsg){},
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    return res;
  }



  String getWeekdayName(String day) {
    switch (day) {
      case '1':
        return '周一';
      case '2':
        return '周二';
      case '3':
        return '周三';
      case '4':
        return '周四';
      case '5':
        return '周五';
      case '6':
        return '周六';
      case '7':
        return '周日';
      default:
        return '输入的数字必须在1到7之间';
    }
  }
}
