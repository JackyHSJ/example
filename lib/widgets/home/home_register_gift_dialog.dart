import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frechat/models/res/member_register_res.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/widgets/home/ribbon_crystal_dialog.dart';

/// 首次註冊成功贈送禮物對話框。
class HomeRegisterGiftDialog extends StatelessWidget {
  //直接跳這個選擇對話框給使用。
  static Future show(BuildContext context,
      {required RegisterBenefit registerBenefit,
      num? gender,
      bool barrierDismissible = false,
      Key? key}) async {
    //Use showDialog here.
    await showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) {
        return HomeRegisterGiftDialog(
            registerBenefit: registerBenefit, gender: gender, key: key);
      },
    );
  }

  const HomeRegisterGiftDialog(
      {required this.registerBenefit, this.gender, super.key});

  //The source model.
  final RegisterBenefit registerBenefit;

  /// 性别(0:女生,1:男生)
  final num? gender;

  @override
  Widget build(BuildContext context) {
    log (jsonEncode(registerBenefit.toJson()));
    String? goldCoinText =
        gender == 0 ? registerBenefit.femaleCoin : registerBenefit.maleCoin;

    // gift 與金幣是二選一，這邊根據金幣是否有東西來判斷要顯示哪種。
    //文字
    String displayText = '';
    if (goldCoinText == null) {
      //顯示禮物
      displayText = '您已完善信息\n赠送您 ${registerBenefit.giftName}\n预祝您展开美好的一天';
    } else {
      //顯示金幣
      displayText = '您已完善信息\n赠送您 $goldCoinText 金币\n预祝您展开美好的一天';
    }

    //Icons
    Widget giftItem = Container();
    if (goldCoinText == null) {
      //顯示禮物
      giftItem = _giftUrlItem(context, registerBenefit.giftUrl, registerBenefit.giftName);
    } else {
      //顯示金幣
      giftItem = _giftAssetItem(context, 'assets/strike_up_list/treasure.png', '金币');
    }

    return RibbonCrystalDialog(
      title: '注册成功',
      bodyText: displayText,
      bodyWidget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: giftItem),
      ),
      confirmBtnText: '确定',
    );
  }

  //Form a gift item.
  Widget _giftUrlItem(BuildContext context, String? giftUrl, String? giftName) {
    List<Widget> children = [];

    //圖片
    if (giftUrl != null) {
      children.add(SizedBox(
          width: 72,
          height: 72,
          child: CachedNetworkImage(
              imageUrl: HttpSetting.baseImagePath + giftUrl)));
    } else {
      children.add(const SizedBox(
          width: 72,
          height: 72));
    }

    children.add(const SizedBox(height: 16,));

    //名稱
    if (giftName != null) {
      children.add(Text(
        giftName,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.grey.shade800),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  //Form a gift item.
  Widget _giftAssetItem(BuildContext context, String giftAssetPath, String giftName) {
    List<Widget> children = [];

    //圖片
    children.add(SizedBox(
        width: 128,
        height: 128,
        child: Image.asset(giftAssetPath)));

    //名稱
    children.add(Text(
      giftName,
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
