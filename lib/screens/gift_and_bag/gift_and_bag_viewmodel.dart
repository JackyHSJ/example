import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/account/ws_account_call_package_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_get_gift_detail_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_get_gift_type_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_point_coin_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_call_package_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_gift_detail_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_gift_type_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_point_coin_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';

class GiftAndBagViewModel {
  WidgetRef ref;
  ViewChange? setState;
  BuildContext context;
  TickerProvider tickerProvider;

  GiftAndBagViewModel({
      required this.ref,
      this.setState,
      required this.context,
      required this.tickerProvider
  });

  // WsAccountGetGiftTypeRes? getGiftTypeRes;
  List<dynamic> tabDataList = [];
  bool giftCategoryLoading = true;
  late TabController tabController;
  String myCoin = '';

  // 取得禮物分類 3-90
  Future<void> initGiftCategory() async {
    String resultCodeCheck = '';
    final WsAccountGetGiftTypeReq reqBody = WsAccountGetGiftTypeReq.create();
    final WsAccountGetGiftTypeRes giftCategoryRes = await ref.read(accountWsProvider).wsAccountGetGiftType(reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      //
    } else {
      if (context.mounted) {
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
      return;
    }

    giftCategoryRes!.giftCategoryList!.sort((a,b)=>a.seq!.compareTo(b.seq!));

    for (int i = 0; i < giftCategoryRes!.giftCategoryList!.length; i++) {

      // 只取禮物分類有開啟的. 0: 開啟, 1: 關閉
      WsAccountGetGiftDetailRes getGiftDetailRes = await getGiftCategoryDetail(giftCategoryRes!.giftCategoryList![i].id!);
      // 排序由小到大
      getGiftDetailRes.giftList?.sort((a, b) => b.seq!.compareTo(a.seq!));

      tabDataList.add(TabGiftData(giftCategoryRes!.giftCategoryList![i].codeName!, getGiftDetailRes));
      // if (getGiftTypeRes!.giftCategoryList?[i].status == 0) {
      //   WsAccountGetGiftDetailRes getGiftDetailRes = await getGiftCategoryDetail(getGiftTypeRes!.giftCategoryList![i].id!);
      //   // 排序由小到大
      //   getGiftDetailRes.giftList?.sort((a, b) => b.seq!.compareTo(a.seq!));
      //
      //   tabDataList.add(TabGiftData(getGiftTypeRes!.giftCategoryList![i].codeName!, getGiftDetailRes));
      // }

    }

    // 取得背包禮物 3-93
    WsAccountCallPackageRes accountCallPackageRes = await getBag();
    tabDataList.add(TabBagData("背包", accountCallPackageRes!));

    tabController =
        TabController(vsync: tickerProvider, length: tabDataList.length);

    WsMemberPointCoinRes memberPointCoinRes = await getMyCoin();
    myCoin = memberPointCoinRes.coins.toString();

    setState!(() {
      giftCategoryLoading = false;
    });
  }

  // 取得禮物分類明細 3-91
  Future<WsAccountGetGiftDetailRes> getGiftCategoryDetail(num id) async {
    String resultCodeCheck = '';
    final reqBody = WsAccountGetGiftDetailReq.create(categoryId: id);

    final WsAccountGetGiftDetailRes res = await ref.read(accountWsProvider).wsAccountGetGiftDetail(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg);

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
    } else {
      if (context.mounted) {
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
    }

    return res;
  }

  // 取得背包
  Future<WsAccountCallPackageRes> getBag() async {
    String resultCodeCheck = '';

    final reqBody = WsAccountCallPackageReq.create();

    WsAccountCallPackageRes res = await ref.read(accountWsProvider).wsAccountCallPackage(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg);

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
    } else {
      if (context.mounted) {
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
    }

    return res;
  }

  Future<WsMemberPointCoinRes> getMyCoin() async {
    String resultCodeCheck = '';

    final reqBody = WsMemberPointCoinReq.create();
    WsMemberPointCoinRes memberPointCoinRes = await ref.read(memberWsProvider).wsMemberPointCoin(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMemberPointCoin(memberPointCoinRes);
    } else {
      if (context.mounted) {
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
    }


    return memberPointCoinRes;
  }

  GiftListInfo getGiftListInfoFromFreBackPackListInfo({FreBackPackListInfo? freBackPackListInfo,String? giveGiftNum}){
    return GiftListInfo(
        giftImageUrl: freBackPackListInfo?.giftImageUrl,
        svgaFileId: freBackPackListInfo?.svgaFileId,
        svgaUrl: freBackPackListInfo?.svgaUrl,
        giftId: freBackPackListInfo?.giftId,
        giftSendAmount: int.parse(giveGiftNum??'0'),
        giftName: freBackPackListInfo?.giftName,
        coins: freBackPackListInfo?.coins,
        categoryName: 'bag',
      giftType: 1,
    );
  }

  GiftListInfo getUpdateGiftListInfo({GiftListInfo? giftListInfo,String? giveGiftNum}){
    return GiftListInfo(
        giftImageUrl: giftListInfo?.giftImageUrl,
        svgaFileId: giftListInfo?.svgaFileId,
        svgaUrl: giftListInfo?.svgaUrl,
        giftId: giftListInfo?.giftId,
        giftSendAmount: int.parse(giveGiftNum??'0'),
        giftName: giftListInfo?.giftName,
        coins: giftListInfo?.coins,
        categoryName: giftListInfo?.categoryName,
      giftType: 0,
    );
  }
}

class TabGiftData {
  final String title;
  final data;
  TabGiftData(this.title, this.data);
}

class TabBagData {
  final String title;
  final data;
  TabBagData(this.title, this.data);
}
