import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frechat/models/res/member_register_res.dart';
import 'package:frechat/widgets/home/ribbon_crystal_dialog.dart';

/// 首次註冊成功優惠對話框。這個只有男性使用者才會顯示。
class HomeRegisterBenefitDialog extends StatelessWidget {
  //直接跳這個選擇對話框給使用。
  static Future show(BuildContext context,
      {required RegisterBenefit registerBenefit,
      bool barrierDismissible = false,
      Key? key}) async {
    //Use showDialog here.
    await showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) {
        return HomeRegisterBenefitDialog(
            registerBenefit: registerBenefit, key: key);
      },
    );
  }

  const HomeRegisterBenefitDialog({required this.registerBenefit, super.key});

  //The source model.
  final RegisterBenefit registerBenefit;

  @override
  Widget build(BuildContext context) {
    // log(jsonEncode(registerBenefit.toJson()));

    List<Widget> items = [];

    //信息優惠
    items.add(SizedBox(
      width: 128,
      child: _benefitItem(context, 'assets/strike_up_list/envelope.png',
          '每日可对 ${registerBenefit.maleFreeWordPerDay} 位用户传送 ${registerBenefit.maleFreeWordPerDayToFemale} 则免费文字信息'),
    ));

    //通話優惠
    items.add(SizedBox(
      width: 128,
      child: _benefitItem(context, 'assets/strike_up_list/message.png',
          '免费视频通话 ${registerBenefit.freeVideoPerMinute} 分钟'),
    ));

    return RibbonCrystalDialog(
      title: '新用户奖励',
      bodyText: '恭喜！您已註册成功并获得奖励\n赶紧去搭讪小姐姐',
      bodyWidget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items,
        ),
      ),
      confirmBtnText: '确定',
    );
  }

  //Form a benefit item.
  Widget _benefitItem(BuildContext context, String imageAssetPath, String desc) {
    List<Widget> children = [];

    //圖片
    children.add(
        SizedBox(width: 64, height: 64, child: Image.asset(imageAssetPath)));

    children.add(const SizedBox(height: 16,));

    //敘述
    children.add(Text(desc,
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: Colors.grey.shade800),
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}
