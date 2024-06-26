// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:frechat/models/ws_req/account/ws_account_get_gift_detail_req.dart';
// import 'package:frechat/models/ws_req/withdraw/ws_withdraw_recharge_reward_req.dart';
// import 'package:frechat/models/ws_res/account/ws_account_get_gift_detail_res.dart';
// import 'package:frechat/models/ws_res/withdraw/ws_withdraw_recharge_reward_res.dart';
// import 'package:frechat/system/base_view_model.dart';
// import 'package:frechat/system/repository/http_setting.dart';
// import 'package:frechat/system/repository/response_code.dart';
// import 'package:frechat/system/util/cache_network_image_util.dart';
// import 'package:frechat/system/util/recharge_util.dart';
// import 'package:frechat/widgets/shared/img_util.dart';
// import 'package:frechat/widgets/shared/loading_animation.dart';
// import '../../../system/providers.dart';
// import '../bottom_sheet/recharge/calling_recharge_sheet.dart';
// import '../bottom_sheet/recharge/recharge_bottom_sheet.dart';
//
//
// // 通話首充彈窗
// class CallingRechargeDialog extends ConsumerStatefulWidget {
//   final String msg;
//   final int callingPage;
//
//    const CallingRechargeDialog({
//     super.key,
//     required this.msg,
//     required this.callingPage
//   });
//
//   @override
//   ConsumerState<CallingRechargeDialog> createState() => _CallingRechargeDialogState();
// }
//
// class _CallingRechargeDialogState extends ConsumerState<CallingRechargeDialog> {
//
//   String get msg => widget.msg;
//   bool isLoading = true;
//   List<ChargeGift?> rechargeRewardList = [];
//   // List<GiftListInfo>? giftList = [];
//   bool isAndroid = Platform.isAndroid;
//   bool isIOS = Platform.isIOS;
//
//   @override
//   void initState() {
//     super.initState();
//     _getPage();
//     _getDataResult();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   void deactivate(){
//     _resetPage();
//     super.deactivate();
//   }
//
//   _getPage(){
//     ref.read(userInfoProvider).currentPage = 3;
//     if (msg != '') BaseViewModel.showToast(context, msg);
//   }
//
//   _resetPage(){
//     if (ref.read(userInfoProvider).currentPage == 4) {
//       ref.read(userInfoProvider).currentPage = 3;
//     } else {
//       ref.read(userInfoProvider).currentPage = widget.callingPage;
//     }
//   }
//
//   _getDataResult() async {
//     List<dynamic> results = await Future.wait([
//       _getWithdrawRechargeReward(),
//       // _getGiftCategoryDetail(),
//     ]);
//
//     // if (results[0] != true|| results[1] != true) return;
//     if (results[0] != true) return;
//
//     isLoading = false;
//     setState(() {});
//   }
//
//   // GiftListInfo? _getGiftInfo(ChargeGift chargeGift) {
//   //   GiftListInfo? matchedGift = giftList?.firstWhere((item) => item.giftId == chargeGift.giftId);
//   //   return matchedGift;
//   // }
//
//   // 取得首充獎勵 9-8
//   Future<bool>  _getWithdrawRechargeReward() async {
//     String resultCodeCheck = '';
//     final WsWithdrawRechargeRewardReq reqBody = WsWithdrawRechargeRewardReq.create();
//
//     final WsWithdrawRechargeRewardRes res = await ref.read(withdrawWsProvider).wsWithdrawRechargeReward(reqBody,
//         onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
//         onConnectFail: (errMsg) => resultCodeCheck = errMsg
//     );
//
//     if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
//       if (isIOS) {
//         rechargeRewardList = res.newUserChargeReward?.iosFristChargeGift ?? [];
//       } else {
//         rechargeRewardList = res.newUserChargeReward?.androidFristChargeGift ?? [];
//       }
//       return true;
//     } else {
//       if (context.mounted) BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
//       return false;
//     }
//   }
//
//   // // 取得禮物明細 3-91
//   // Future<bool> _getGiftCategoryDetail() async {
//   //   String resultCodeCheck = '';
//   //   final reqBody = WsAccountGetGiftDetailReq.create(type: 1); // type: 1 是全撈
//   //
//   //   final WsAccountGetGiftDetailRes res = await ref.read(accountWsProvider).wsAccountGetGiftDetail(reqBody,
//   //       onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
//   //       onConnectFail: (errMsg) => resultCodeCheck = errMsg);
//   //
//   //   if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
//   //     giftList = res.giftList ?? [];
//   //     return true;
//   //   } else {
//   //     if (context.mounted) BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
//   //     return false;
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SizedBox(
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               _buildBackgroundImg(),
//               _buildAwardContent(),
//               _buildRechargeButton()
//             ],
//           ),
//         ),
//         // 取消
//         _buildCancelButton()
//       ],
//     );
//   }
//
//   Widget _buildBackgroundImg (){
//     return ImgUtil.buildFromImgPath('assets/images/recharge.png', size: 336);
//   }
//
//   _buildAwardContent() {
//
//     if (isLoading) return const SizedBox();
//
//     if (rechargeRewardList.isEmpty) return const SizedBox();
//
//     List<Widget> list = [];
//     rechargeRewardList.asMap().forEach((index, item) {
//       if (item?.giftType == 0) {
//         list.add(_buildCoinContent(item));
//       } else if (item?.giftType == 1){
//         list.add(_buildGiftContent(item));
//       }
//     });
//
//     if (list.isEmpty) return const SizedBox();
//
//     return Positioned(
//         top: 145,
//         left: 70,
//         child: SizedBox(
//           width: 200,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: list,
//           ),
//         )
//     );
//   }
//
//   Widget _buildGiftContent(ChargeGift? gift) {
//
//     if (gift == null || gift.giftId == null) return const SizedBox();
//
//     final String giftUrl = gift.giftImageUrl ?? '';
//     final String giftName = gift.giftName ?? '';
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
//       width: 60,
//       height: 80,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12.0),
//         color: const Color(0xffF6F6F6).withOpacity(0.9),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CachedNetworkImageUtil.load(HttpSetting.baseImagePath + giftUrl, size: 42),
//           const SizedBox(height: 5),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Text(
//               '${giftName}',
//               style: const TextStyle(
//                   color: Color(0xFFE6803D),
//                   fontSize: 10, fontWeight: FontWeight.w700,
//                   height: 1.6,
//                   decoration: TextDecoration.none
//               ),
//               overflow: TextOverflow.visible,
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCoinContent(ChargeGift? gift) {
//
//     if (gift == null || gift.sendAmount == 0 || gift.sendAmount == '0') return const SizedBox();
//
//     final sendAmount = gift.sendAmount ?? 0;
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
//       width: 60,
//       height: 80,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12.0),
//         color: const Color(0xffF6F6F6).withOpacity(0.9),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ImgUtil.buildFromImgPath('assets/common/icon_coin_large.png', size: 42),
//           const SizedBox(height: 5),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Text(
//               '+${sendAmount}',
//               style: const TextStyle(
//                   color: Color(0xFFE6803D),
//                   fontSize: 10, fontWeight: FontWeight.w700,
//                   height: 1.6,
//                   decoration: TextDecoration.none
//               ),
//               overflow: TextOverflow.visible,
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRechargeButton (){
//     return Positioned(
//       top: 253,
//       child: GestureDetector(
//         onTap: () {
//           RechargeUtil.showCallingRecharge(widget.callingPage, fromDialog: true);
//         },
//         child: Container(
//           color: const Color.fromRGBO(0, 0, 0, 0.0),
//           width: 200,
//           height: 50,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCancelButton(){
//     return GestureDetector(
//       onTap: () {
//         ref.read(userInfoProvider).currentPage = widget.callingPage;
//         Navigator.pop(context);
//       },
//       child: Image.asset('assets/images/icon_clear.png', width: 26, height: 36),
//     );
//   }
// }
