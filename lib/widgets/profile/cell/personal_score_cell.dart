


import 'package:flutter/material.dart';
import 'package:frechat/models/ws_res/contact/ws_contact_search_friend_benefit_res.dart';
import 'package:frechat/system/constant/fund_history_type.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:intl/intl.dart';
import 'package:frechat/system/repository/http_setting.dart';
import '../../constant_value.dart';
import '../../theme/original/app_colors.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:flutter_screenutil/src/size_extension.dart';

// 時間格式
String formatDateTime(DateTime dateTime) {
  DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  String formatted = formatter.format(dateTime);
  return formatted;
}


class PersonalScoreCell extends StatelessWidget {
  PersonalScoreCell({super.key, required this.model});
  ContactFriendListInfo model;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildAvatar(),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNicknameGenderAgeCer(),
            _buildFundHistoryTypeAndTime(),
            _buildAward()
          ],
        )
      ],
    );
  }


  // 用戶頭貼
  _buildAvatar(){

    final num gender = model.gender ?? 0;
    final String avatar =  model.avatar ?? '';
    final bool realPersonAuth = model.realPersonAuth == 1;

    return (avatar == '')
        ? AvatarUtil.defaultAvatar(gender, size: 64.w)
        : AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatar, size: 64.w);
  }

  // 名稱, 性別, 年齡, 實名認證
  _buildNicknameGenderAgeCer() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${model.interactFreUserName}',style: const TextStyle(color: AppColors.mainDark,fontSize: 14.0, fontWeight:FontWeight.w700, height: 1.5),),
        const SizedBox(width: 4),
        Container(
          height: 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99.0),
            color: (model.gender == 0) ? const Color(0xFFFD73A5) : const Color(0xFF54B5DF),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 4,right: 6),
            child: Row(
              children: [
                Image.asset('assets/profile/profile_contact_${model.gender == 0 ? 'female' : 'male'}_icon.png', width: 12, height: 12),
                const SizedBox(width: 2),
                Text('${model.age}',style: const TextStyle(color: Color(0xFFFFFFFF),fontSize: 10.0, fontWeight:FontWeight.w500, height: 1.5),)
              ],
            ),
          ),
        ),
        const SizedBox(width: 4),
        Visibility(
          visible: model.realNameAuth == 1,
          child: Image.asset('assets/profile/profile_contact_name_certi_cyan_icon.png',width: 16, height: 16
          ),
        )
      ],
    );
  }

  // 帳變, 時間
  _buildFundHistoryTypeAndTime() {
    FundHistoryCodeMapping codeMapping = FundHistoryCodeMapping();

    final createTime = model.createTime?.toInt();
    final int type = model.type?.toInt() ?? 0;
    final fundHistoryText = codeMapping.getTypeText(type);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Text(fundHistoryText, style: const TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w700, fontSize: 12)),
          const SizedBox(width: 4),
          Text(formatDateTime(DateTime.fromMillisecondsSinceEpoch(createTime!)), style: const TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w500, fontSize: 12)),
        ],
      )
    );
  }

  _buildAward() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/profile/profile_contact_coin_orange_icon.png',width: 24, height: 24),
        const SizedBox(width: 2),
        const Text('+', style: TextStyle(color: Color(0xFFFF9A7A), fontWeight: FontWeight.w700, fontSize: 16)),
        const SizedBox(width: 1),
        Text('${model.amount}', style: const TextStyle(color: Color(0xFFFF9A7A), fontWeight: FontWeight.w700, fontSize: 16))
      ],
    );
  }
}
