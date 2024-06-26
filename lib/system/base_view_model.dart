// ignore_for_file: use_build_context_synchronously

import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';
import 'package:frechat/system/websocket/websocket_status.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:page_transition/page_transition.dart';

import '../widgets/theme/original/app_colors.dart';
import 'package:flutter_screenutil/src/size_extension.dart';

class BaseViewModel {
  static bool get isIos => Platform.isIOS;
  static bool get isAndroid => Platform.isAndroid;
  static bool get isWeb => kIsWeb;

  static BuildContext getGlobalContext() {
    return GlobalData.globalKey.currentContext!;
  }

  static void showToast(BuildContext context, String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
        textColor: Colors.white,
        fontSize: 12.0,
    );
  }

  static void copyText(BuildContext context, {required String copyText}) {
    Clipboard.setData(ClipboardData(text: copyText));
    showToast(context, '已复制: $copyText');
  }

  static void clearAllFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  ///MARK: 推頁面 偷懶用
  static void popPage(BuildContext context, {dynamic sendMessage}) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context, sendMessage);
    }
  }

  ///MARK: 推新的一頁 ,泛型回傳類型
  static Future<T?> pushPage<T extends Object>(BuildContext context, Widget page, {
    PageTransitionType? pageTransitionType,
    Object? arguments
  }) {
    final RouteSettings routeSettings = RouteSettings(name: page.toString(), arguments: arguments);
    final Route<T> route = MaterialPageRoute(
        builder: (context) => page,
        settings: routeSettings
    );
    final Route<T>? pageTransition = _getPageTransition(type: pageTransitionType, page: page, routeSettings: routeSettings);
    return Navigator.push(
      context,
      pageTransition ?? route,
    );
  }

  ///MARK: 取代當前頁面
  static Future<void> pushReplacement(BuildContext context, Widget page) async {
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
  }

  ///MARK: 將前面的頁面全部清除只剩此頁面
  static Future<void> pushAndRemoveUntil(BuildContext context, Widget page, {
    PageTransitionType? pageTransitionType
  }) async {
    final RouteSettings routeSettings = RouteSettings(name: page.toString());
    final Route route = MaterialPageRoute(
        builder: (context) => page,
        settings: routeSettings
    );
    final Route<void>? pageTransition = _getPageTransition(type: pageTransitionType, page: page, routeSettings: routeSettings);
    await Navigator.pushAndRemoveUntil<void>(
      context,
      pageTransition ?? route,
      (route) => false,
    );
  }

  ///MARK: Stack MainScreen推回主頁用，避免重複new Navi Bar
  static Future<void> pushNamedAndRemoveUntil(BuildContext context, {
    required String newRouteName,
    String routeName = '/'
  }) async {
    Navigator.pushNamedAndRemoveUntil(context, newRouteName, ModalRoute.withName(routeName));
  }

  ///MARK: 推一個疊加頁面
  static Future<void> pushStackPage(BuildContext context, Widget page) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // set to false
        pageBuilder: (_, __, ___) => page,
      ),
    );
  }

  static Route<T>? _getPageTransition<T extends Object>({
    PageTransitionType? type,
    required Widget page,
    required RouteSettings routeSettings
  }) {
    Route<T>? pageTransition;
    if(type != null) {
      pageTransition = PageTransition(
        type: type, // 这里定义过渡效果
        child: page,
        settings: routeSettings
      );
    }

    return pageTransition;
  }

  static Widget maleOrFemaleAvatarWidget(num gender, {double? size}) {
    size ??= 64.w;

    return Image.asset(
      gender == 0
          ? 'assets/avatar/female_default_avatar.png'
          : 'assets/avatar/male_default_avatar.png',
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }

  static Future<void> waitUntilToWebSocketConnect({
    required bool isLoginState
  }) async {
    if (isLoginState == false) {
      return ;
    }

    await Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 100)); // 檢查頻率，每100毫秒檢查連線狀態
      return WebSocketHandler.socketStatus != SocketStatus.SocketStatusConnected;
    });
  }

  // PopupRoute
  // Dialog
  // BottomSheet
  // showMenu
  // showDatePicker
  // showTimePicker
  // 只會 popup 彈窗類
  static popupDialog() {
    BuildContext currentContext = BaseViewModel.getGlobalContext();
    Navigator.popUntil(currentContext, (route) {
      bool isVisible = route is PopupRoute;
      bool canPop = Navigator.canPop(currentContext);
      return !isVisible || !canPop; // return true 將不再 pop
    });
  }

  // 來電時必須把某些頁面先 pop 掉
  static popupPageOnCalling(String routeName) {
    BuildContext currentContext = BaseViewModel.getGlobalContext();
    Navigator.popUntil(currentContext, (route) {
      String? currentRoute = route.settings.name;
      if (currentRoute == routeName) {
        BaseViewModel.popupDialog();
        BaseViewModel.popPage(currentContext);
      }
      return true; // return true 將不再 pop
    });
  }

  /// 充值彈窗, 太多地方使用 提出為共用元件
  static void showRechargeBottomSheet({
    required AppTheme theme,
    required UserInfoModel userInfoModel
}) {
    final num rechargeCounts = userInfoModel.memberPointCoin?.depositCount ?? 0; // 充值次數
    final bool rechargeBottomSheet = RechargeUtil.rechargeBottomSheet;
    if (rechargeBottomSheet) return;
    if (rechargeCounts == 0) {
      RechargeUtil.showFirstTimeRechargeDialog('余额不足，请先充值'); // 開啟首充彈窗
    } else {
      RechargeUtil.showRechargeBottomSheet(theme: theme); // 開啟充值彈窗
    }
  }
}
