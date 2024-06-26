import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import '../../models/ws_req/mission/ws_mission_search_status_req.dart';
import '../../models/ws_res/detail/ws_detail_search_list_coin_res.dart';
import '../../models/ws_res/member/ws_member_fate_recommend_res.dart';
import '../../models/ws_res/mission/ws_mission_search_status_res.dart';
import '../../system/providers.dart';

class StrikeUpListExtension {
  //static List<MissionStatusList> listMissions = [];

  ///取得指定任務
  static Future<MissionStatusList> getMyMission(num target, WidgetRef ref) async {
    MissionStatusList missionStatus = MissionStatusList();
    WsMissionSearchStatusRes? wsMSSRes = await getMissionInfo(ref);
    if (wsMSSRes != null && wsMSSRes.list != null) {
      missionStatus = wsMSSRes.list!.where((element) => element.target == target).toList()[0];
    }
    return missionStatus;
  }

  ///api 15-1 取得任務列表
  static Future<WsMissionSearchStatusRes?> getMissionInfo(WidgetRef ref) async {
    WsMissionSearchStatusRes? wsMSSRes; // = WsMissionSearchStatusRes();
    final reqBody = WsMissionSearchStatusReq.create();
    try {
      //api 15-1
      wsMSSRes = await ref.read(missionWsProvider).wsMissionSearchStatus(reqBody, onConnectSuccess: (succMsg) {
        // ignore: avoid_print
        print('succMsg:$succMsg');
      }, onConnectFail: (errMsg) {
        // ignore: avoid_print
        print('errMsg:$errMsg');
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    if (wsMSSRes != null) {
      //listMissions = wsMSSRes.list ?? [];
    }
    return wsMSSRes;
    /*
    final container = ProviderContainer();
    String resultCodeCheck = '';
    String errorMsgCheck = '';
    WsMissionSearchStatusReq req = WsMissionSearchStatusReq.create();

    final memberModifyUserProvider = FutureProvider<WsMissionSearchStatusRes?>((ref) async {
      WsMissionSearchStatusRes res = await ref
          .read(missionWsProvider)
          .wsMissionSearchStatus(req, onConnectSuccess: (succMsg) => resultCodeCheck = succMsg, onConnectFail: (errMsg) => errorMsgCheck = errMsg);
      return res;
    });
    final result = await container.read(memberModifyUserProvider.future);

    container.dispose();
    return result!.list!;
    */
  }

  ///頭像邊線顏色(我的)
  static Color myAvatarBorderColor({num? gender}) {
    //gender = gender ?? memberInfo.gender ?? 9;
    return gender == 0
        ? AppColors.mainPink
        : gender == 1
            ? const Color.fromRGBO(51, 138, 243, 1)
            : Colors.black;
  }

  static List<Color> colorGradient = [];

  // 在線圖示
  static Widget online() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xff18E469),
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
      ),
    );
  }
}

extension GetStringExtension on String? {
  ///任務狀態
  String asMissionStatus() {
    return this == null
        ? ''
        : this == '-1'
            ? '前往'
            : '已完成';
    /*
        : this == '0'
            ? '任務完成但是未領取'
            : this == '1'
                ? '任務完成並且已領取'
                : this == '-1'
                    ? '未完成任務未領取任務'
                    : '';
                    */
  }

  int asInt() {
    return int.tryParse(this ?? '0') ?? 0;
  }

  double asDouble() {
    return double.tryParse(this ?? '0') ?? 0;
  }

  Future<String> asTxtList() async {
    String txtList = '';
    //String data = await rootBundle.loadString('assets/txt/personal_benefit_help.txt');
    String data = this ?? '';
    List<String> contentList = const LineSplitter().convert(data);
    for (int i = 0; i < contentList.length; i++) {
      txtList += '${contentList[i]}\n';
    }

    return txtList;
  }
}

//棄用
extension GetDetailListInfoExtension on DetailListInfo? {
  FateListInfo asFateListInfo() {
    FateListInfo fateListInfo = FateListInfo();
    return this == null
        ? fateListInfo
        : FateListInfo(
            nickName: this!.fundHistoryJson!.interactNickName ?? '',
          );
  }
}

extension GetNumExtension on num? {
  ///自己的性別圖示
  Widget getGenderIcon() {
    return Icon(
        this == 1
            ? Icons.male
            : this == 0
                ? Icons.female
                : Icons.error,
        color: Colors.white,
        size: 12);
  }

  String myAvatarPath() {
    //gender = gender ?? memberInfo.gender ?? 9;
    return this == 1
        ? 'assets/user_info_view/MaleAvatar.png'
        : this == 0
            ? 'assets/user_info_view/FemaleAvatar.png'
            : 'assets/images/default_avatar.png';
  }

  ///預設頭像(其他成員)
  Image defAvatarImage() {
    //gender = gender ?? memberInfo.gender ?? 9;
    return this == 0
        ? Image.asset('assets/user_info_view/MaleAvatar.png')
        : this == 1
            ? Image.asset('assets/user_info_view/FemaleAvatar.png')
            : Image.asset('assets/images/default_avatar.png');
  }

  ///頭像邊線顏色(其他成員)num? gender
  Color defAvatarBorderColor() {
    //gender = gender ?? memberInfo.gender ?? 9;
    return this == 1
        ? AppColors.mainPink
        : this == 0
            ? const Color.fromRGBO(51, 138, 243, 1)
            : Colors.black;
  }

  //[Dep]: Stupid and ugly and wrong place.
  // ///提現狀態
  // String asWithdrawalStatus() {
  //   return this == null
  //       ? ''
  //       : this == 0
  //           ? '提现中'
  //           : this == 1
  //               ? '提现成功'
  //               : this == 2
  //                   ? '提现被拒'
  //                   : this == 3
  //                       ? '提现失败'
  //                       : '';
  // }

/*
  String asDateTime() {
    String formattedDate = '';
    num check = this ?? 0;
    int timestamp = check.toInt();
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    //formattedDate = DateFormat("yyyy-MM-dd HH:mm:ss")!.format(dateTime);
    if (this == null) {
      return '';
    }
  }
*/
  ///心动/搭讪
  String asLoveLabel() {
    //print('label:$this');
    return this == null
        ? ''
        : this == 0
            ? '心动'
            : this == 1
                ? '搭讪'
                : '';
  }
}

///性別
String asGender(num? gender) {
  String text = '';
  switch(gender) {
    case 0:
      text = '女';
      break;
    case 1:
      text = '男';
      break;
    default:
      break;
  }
  return text;
}

///感情
String asMaritalStatus(num? marital) {
  String text = '';
  switch(marital) {
    case 0:
      text = '單身';
      break;
    case 1:
      text = '已婚';
      break;
    case 2:
      text = '寻爱中';
      break;
    case 3:
      text = '有伴侣';
      break;
    case 4:
      text = '离异';
      break;
    default:
      break;
  }
  return text;
}

///身高
String asHeight(num? height) {
  return height == null ? '' : '$height cm';
}

///體重
String asWeight(num? weight) {
  return weight == null ? '' : '$weight kg';
}

///收入
String asAnnualIncome(num? income) {
  return income == null ? '' : '$income';
}
