import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_req/account/ws_account_get_gift_detail_req.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_recharge_reward_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_gift_detail_res.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_recharge_reward_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/widgets/shared/bottom_sheet/recharge/recharge_bottom_sheet.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

// 首充彈窗
class RechargeDialog extends ConsumerStatefulWidget {
  final String msg;

  const RechargeDialog({
    super.key,
    required this.msg,
  });

  @override
  ConsumerState<RechargeDialog> createState() => _RechargeDialogState();
}

class _RechargeDialogState extends ConsumerState<RechargeDialog> {

  String get msg => widget.msg;
  bool isLoading = true;
  List<ChargeGift?> rechargeRewardList = [];
  // List<GiftListInfo>? giftList = [];
  bool isAndroid = Platform.isAndroid;
  bool isIOS = Platform.isIOS;
  late AppTheme _theme;
  late AppImageTheme _appImageTheme;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate(){
    super.deactivate();
  }

  _init(){
    if (msg != '') BaseViewModel.showToast(context, msg);
    _getDataResult();
  }

  _getDataResult() async {
    List<dynamic> results = await Future.wait([
      _getWithdrawRechargeReward(),
      // _getGiftCategoryDetail(),
    ]);

    // if (results[0] != true|| results[1] != true) return;
    if (results[0] != true) return;

    isLoading = false;
    setState(() {});
  }

  // GiftListInfo? _getGiftInfo(ChargeGift chargeGift) {
  //   GiftListInfo? matchedGift = giftList?.firstWhere((item) => item.giftId == chargeGift.giftId);
  //   return matchedGift;
  // }

  // 取得首充獎勵 9-8
  Future<bool>  _getWithdrawRechargeReward() async {
    String resultCodeCheck = '';
    final WsWithdrawRechargeRewardReq reqBody = WsWithdrawRechargeRewardReq.create();

    final WsWithdrawRechargeRewardRes res = await ref.read(withdrawWsProvider).wsWithdrawRechargeReward(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      if (isIOS) {
        rechargeRewardList = res.newUserChargeReward?.iosFristChargeGift ?? [];
      } else {
        rechargeRewardList = res.newUserChargeReward?.androidFristChargeGift ?? [];
      }
      return true;
    } else {
      if (context.mounted) BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appImageTheme = _theme.getAppImageTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildBackgroundImg(),
              _buildAwardContent(),
              _buildRechargeButton()
            ],
          ),
        ),
        // 取消
        _buildCancelButton()
      ],
    );
  }


  Widget _buildBackgroundImg (){
    return ImgUtil.buildFromImgPath(_appImageTheme.firstRechargeImage, size: 336);
  }

  _buildAwardContent() {

    if (isLoading) return const SizedBox();

    if (rechargeRewardList.isEmpty) return const SizedBox();

    List<Widget> list = [];
    rechargeRewardList.asMap().forEach((index, item) {
      if (item?.giftType == 0) {
        list.add(_buildCoinContent(item));
      } else if (item?.giftType == 1){
        list.add(_buildGiftContent(item));
      }
    });

    if (list.isEmpty) return const SizedBox();

    return Positioned(
      top: 145,
      left: 70,
      child: SizedBox(
        width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: list,
        ),
      )
    );
  }

  Widget _buildGiftContent(ChargeGift? gift) {

    if (gift == null || gift.giftId == null) return const SizedBox();

    final String giftUrl = gift.giftImageUrl ?? '';
    final String giftName = gift.giftName ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color(0xffF6F6F6).withOpacity(0.9),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CachedNetworkImageUtil.load(HttpSetting.baseImagePath + giftUrl, size: 42),
          const SizedBox(height: 5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              '${giftName}',
              style: const TextStyle(
                  color: Color(0xFFE6803D),
                  fontSize: 10, fontWeight: FontWeight.w700,
                  height: 1.6,
                  decoration: TextDecoration.none
              ),
              overflow: TextOverflow.visible,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCoinContent(ChargeGift? gift) {

    if (gift == null || gift.sendAmount == 0 || gift.sendAmount == '0') return const SizedBox();

    final sendAmount = gift.sendAmount ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color(0xffF6F6F6).withOpacity(0.9),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImgUtil.buildFromImgPath('assets/common/icon_coin_large.png', size: 42),
          const SizedBox(height: 5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              '+${sendAmount}',
              style: const TextStyle(
                  color: Color(0xFFE6803D),
                  fontSize: 10, fontWeight: FontWeight.w700,
                  height: 1.6,
                  decoration: TextDecoration.none
              ),
              overflow: TextOverflow.visible,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRechargeButton (){
    return Positioned(
      top: 253,
      child: GestureDetector(
        onTap: () {
          BaseViewModel.popPage(context);
          RechargeUtil.showRechargeBottomSheet(theme: _theme);
          },
        child: Container(
          color: const Color.fromRGBO(0, 0, 0, 0.0),
          width: 200,
          height: 50,
        ),
      ),
    );
  }

  Widget _buildCancelButton(){
    return GestureDetector(
      onTap: () {
        BaseViewModel.popPage(context);
      },
      child: ImgUtil.buildFromImgPath(_appImageTheme.iconCancel, size: 34.w),
    );
  }
}
