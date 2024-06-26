import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_gift_detail_res.dart';
import 'package:frechat/models/ws_res/detail/ws_detail_search_list_coin_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/constant/fund_history_type.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/system/util/tag_icon_util.dart';
import 'package:frechat/widgets/shared/color_box.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/official_notify_circle_avatar.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalBookkeepingCoinIncomeListItem extends ConsumerStatefulWidget {
  final DetailListInfo detailListInfo;
  final List<GiftListInfo> giftListInfo;

  const PersonalBookkeepingCoinIncomeListItem(
      {super.key, required this.detailListInfo, required this.giftListInfo});

  @override
  ConsumerState<PersonalBookkeepingCoinIncomeListItem> createState() =>
      _PersonalBookkeepingCoinListItemState();
}

class _PersonalBookkeepingCoinListItemState extends ConsumerState<PersonalBookkeepingCoinIncomeListItem> {

  late AppTheme _theme;
  late AppImageTheme _appImageTheme;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appImageTheme = _theme.getAppImageTheme;

    return SizedBox(
      height: 88,
      child: Row(
        children: [
          // 頭像
          avatarHandler(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(),
                _subTitle(),
                _coinIncome(),
              ],
            ),
          ),
          // const SizedBox(width: 13),
        ],
      ),
    );
  }

  // 互動者頭像
  Widget interactUserAvatar(String avatar, num gender) {
    return (avatar == '')
        ? AvatarUtil.defaultAvatar(gender, size: 64.w)
        : AvatarUtil.userAvatar(
            HttpSetting.baseImagePath + avatar,
            size: 64.w,
          );
  }

  // 禮物 Icon
  Widget giftIcon(bool isShowGiftImage, String giftImageUrl) {
    return Visibility(
      visible: isShowGiftImage,
      child: Positioned(
        right: 0,
        bottom: 0,
        child: AvatarUtil.userAvatar(
          HttpSetting.baseImagePath + giftImageUrl,
          size: 32.w,
        ),
      ),
    );
  }

  // 自己的頭像
  Widget mySelfAvatar(String avatar, num gender) {
    return (avatar == '')
        ? AvatarUtil.defaultAvatar(gender, size: 64.w)
        : AvatarUtil.userAvatar(
            HttpSetting.baseImagePath + avatar,
            size: 64.w,
          );
  }

  // 官方頭像
  Widget officialAvatar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AvatarUtil.localAvatar('assets/avatar/system_avatar.png', size: 64.w),
        Positioned(
          top: -4,
          right: -4,
          child: Image.asset(
            'assets/strike_up_list/app_tag.png',
            scale: 2.5,
          ),
        ),
      ],
    );
  }

  // Avatar
  Widget avatarHandler() {
    bool isShowGiftImage = false;
    String subTitle = '';
    String giftImageUrl = '';

    // 判斷要不要顯示禮物
    if (widget.detailListInfo.type! < fundHistoryType.length) {
      subTitle += fundHistoryType[widget.detailListInfo.type! as int];
      if (subTitle.contains('礼物')) {
        FundHistoryJsonInfo? fundHistoryJsonInfo =
            widget.detailListInfo.fundHistoryJson;
        final list = widget.giftListInfo
            .where((info) => info.giftId == fundHistoryJsonInfo!.giftId)
            .toList();
        if (list.isEmpty) {
          isShowGiftImage = false;
        } else {
          GiftListInfo giftListInfo = list.first;
          giftImageUrl = giftListInfo.giftImageUrl!;
          isShowGiftImage = true;
        }
      }
    }

    // 官方頭像 / type: 9 -> 每日签到 / 禮物 Icon
    // 官方頭像 / type: 14 -> 註冊獎勵 / 禮物 Icon
    // 官方頭像 / type: 31 -> 首充赠送礼物 / 禮物 Icon
    List<num> showGiftIconList = [9, 14, 31];
    if (showGiftIconList.contains(widget.detailListInfo.type)) {
      if (widget.detailListInfo.fundHistoryJson?.giftId != null) {
        try {
          final giftInfo = widget.giftListInfo
              .where((info) =>
                  info.giftId == widget.detailListInfo.fundHistoryJson?.giftId)
              .toList();
          final String giftUrl = giftInfo[0].giftImageUrl ?? '';
          return Stack(children: [officialAvatar(), giftIcon(true, giftUrl)]);
        } catch (e) {
          print('e: $e');
        }
      }
    }

    if (interactiveTypes.contains(widget.detailListInfo.type)) {
      // 互動者頭像
      final num gender = widget.detailListInfo.gender ?? 0;
      final String avatar = widget.detailListInfo.avatar ?? '';
      return Stack(children: [
        interactUserAvatar(avatar, gender),
        giftIcon(isShowGiftImage, giftImageUrl)
      ]);
    } else if (selfTypes.contains(widget.detailListInfo.type)) {
      // 自己頭像
      final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
      final String avatar =
          ref.read(userInfoProvider).memberInfo?.avatarPath ?? '';
      return mySelfAvatar(avatar, gender);
    } else if (officialTypes.contains(widget.detailListInfo.type)) {
      // 官方頭像
      return Stack(children: [
        officialAvatar(),
        giftIcon(isShowGiftImage, giftImageUrl)
      ]);
    } else {
      return const SizedBox();
      String? avatarPath =
          ref.read(userInfoProvider).memberInfo?.avatarPath ?? '';
      num? gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
      return (avatarPath != null)
          ? AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatarPath,
              size: 64.w)
          : AvatarUtil.defaultAvatar(gender!, size: 64.w);
    }
  }

  // 第一行
  Widget _title() {
    List<Widget> children = [];

    // 與互動者產生金幣帳變
    if (interactiveTypes.contains(widget.detailListInfo.type)) {
      String displayName = widget.detailListInfo.interactFreUserName ?? '';
      if (displayName == '') displayName = '[昵称审核中]';

      // 互動者名稱
      children.add(
        Flexible(
          child: Text(
            displayName,
            style: const TextStyle(
              color: AppColors.mainDark,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
      children.add(const SizedBox(width: 4));
      children.add(_genderAgeTag(
          widget.detailListInfo.gender, widget.detailListInfo.age));
      // children.add(ImgUtil.buildFromImgPath('assets/profile/profile_contact_name_certi_cyan_icon.png', width: 16.w, height: 16.w));
      if (widget.detailListInfo.realNameAuth == 1) {
        children.add(ImgUtil.buildFromImgPath(
            'assets/profile/profile_contact_name_certi_cyan_icon.png',
            width: 16.w,
            height: 16.w));
      }
    } else if (selfTypes.contains(widget.detailListInfo.type)) {
      // 自己
      final String nickName =
          ref.read(userInfoProvider).memberInfo?.nickName ?? '';
      final num realPersonAuth =
          ref.read(userInfoProvider).memberInfo?.realPersonAuth ?? 0;
      final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
      final num age = ref.read(userInfoProvider).memberInfo?.age ?? 0;

      children.add(Flexible(
          child: Text(nickName,
              style: const TextStyle(
                color: AppColors.mainDark,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ))));
      children.add(const SizedBox(width: 4));
      children.add(_genderAgeTag(gender, age));
      children.add(const SizedBox(width: 4));
      // children.add(ImgUtil.buildFromImgPath('assets/profile/profile_contact_name_certi_cyan_icon', width: 16.w, height: 16.w));
      if (widget.detailListInfo.realNameAuth == 1) {
        children.add(ImgUtil.buildFromImgPath(
            'assets/profile/profile_contact_name_certi_cyan_icon',
            width: 16.w,
            height: 16.w));
      }
    } else if (officialTypes.contains(widget.detailListInfo.type)) {
      // 官方
      children.add(Flexible(
          child: Text('${AppConfig.appName}',
              style: TextStyle(
                color: AppColors.mainDark,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ))));
    }

    return Row(
        crossAxisAlignment: CrossAxisAlignment.center, children: children);
  }

  // 第二行
  Widget _subTitle() {
    String subTitle = '';

    if (widget.detailListInfo.type != null) {
      // 執行動作敘述文字
      if (widget.detailListInfo.type! < fundHistoryType.length) {
        subTitle += fundHistoryType[widget.detailListInfo.type! as int];
      }

      // 時間
      if (widget.detailListInfo.createTime != null) {
        final int createTime = widget.detailListInfo.createTime as int;
        subTitle += ' ';
        subTitle += DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(createTime))
            .toString();
      }
    }

    return Text(
      subTitle,
      style: const TextStyle(
        color: AppColors.mainDark,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // 第三行
  Widget _coinIncome() {
    // 官方頭像 / type: 9 -> 每日签到 / 禮物 Icon
    // 官方頭像 / type: 14 -> 註冊獎勵 / 禮物 Icon
    // 官方頭像 / type: 31 -> 首充赠送礼物 / 禮物 Icon
    List<num> showGiftIconList = [9, 14, 31];
    if (showGiftIconList.contains(widget.detailListInfo.type)) {
      if (widget.detailListInfo.fundHistoryJson?.giftId != null) {
        try {
          final giftInfo = widget.giftListInfo
              .where((info) =>
                  info.giftId == widget.detailListInfo.fundHistoryJson?.giftId)
              .toList();
          final String giftName = giftInfo[0].giftName ?? '';

          return Text(
            giftName,
            style: const TextStyle(
              color: AppColors.mainDark,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              overflow: TextOverflow.ellipsis,
            ),
          );
        } catch (e) {
          print('e: $e');
        }
      }
    }

    Widget incomeImage = const SizedBox();
    if (widget.detailListInfo.currency == 0) {
      incomeImage = ImgUtil.buildFromImgPath(_appImageTheme.iconCoin, size: 24.w);
    } else {
      incomeImage = ImgUtil.buildFromImgPath(_appImageTheme.iconPoints, size: 24.w);
    }

    Widget incomeText = const SizedBox();
    if (widget.detailListInfo.amount != null) {
      String incomeStr = '';
      if (widget.detailListInfo.amount! >= 0) {
        incomeStr += '+';
      }

      if (widget.detailListInfo.type == 7 || widget.detailListInfo.type == 33 || widget.detailListInfo.type == 26) {
        incomeStr = '-';
      }

      // 帳變金額取整數
      if (widget.detailListInfo.currency == 0) {
        incomeStr += widget.detailListInfo.amount!.toInt().toString();
      } else {
        incomeStr += widget.detailListInfo.amount!.toString();
      }

      // currency: 0:金幣 1:積分
      if (widget.detailListInfo.currency == 0) {
        incomeText = Text(
          incomeStr,
          style: const TextStyle(
              color: Color(0xffFFBE3F),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1),
        );
      } else {
        incomeText = Text(
          incomeStr,
          style: const TextStyle(
              color: Color(0xffFF9A7A),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1),
        );
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        incomeImage,
        const SizedBox(width: 4),
        incomeText,
      ],
    );
  }

  /// Gender age tag
  Widget _genderAgeTag(num? gender, num? age) {
    return TagIconUtil.tagGenderAgeWidget(gender ?? 1, age ?? 0);
  }
}

// --------------- Other defines -------------------

// 显示与你互动的用户头像
List<num> interactiveTypes = [
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  12,
  15,
  16,
  17,
  18,
  19,
  20,
  21,
  22,
  23,
  24,
  33,
  34
];

// 放置该用户自己的头像
List<num> selfTypes = [11, 13, 26, 27, 30];

// 放置官方头像
List<num> officialTypes = [8, 9, 10, 14, 25, 28, 29, 31, 32];
