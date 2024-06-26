import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/account/ws_account_on_tv_res.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/websocket/websocket_manager.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';
import 'package:frechat/widgets/strike_up_list/strike_up_list_marquee_view_model.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class StrikeUpListMarquee extends ConsumerStatefulWidget {

  const StrikeUpListMarquee({
    super.key,
  });

  @override
  ConsumerState<StrikeUpListMarquee> createState() => _StrikeUpListMarqueeState();
}

class _StrikeUpListMarqueeState extends ConsumerState<StrikeUpListMarquee> with AfterLayoutMixin {
  late WebSocketUtil webSocketUtil;
  late StrikeUpListMarqueeViewModel viewModel;
  late AppTheme _theme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;


  @override
  void initState() {
    webSocketUtil = WebSocketUtil();
    viewModel = StrikeUpListMarqueeViewModel(ref: ref, setState: setState, context: context);
    viewModel.init();
    getTvData();
    super.initState();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    viewModel.start(setState);
  }

  @override
  void dispose() {
    viewModel.stop();
    _disposeWs();
    super.dispose();
  }
  
  _disposeWs() {
    webSocketUtil.onWebSocketListenDispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    return Container(
      height: 58.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.only(left: 10.w),
      decoration: _appBoxDecorationTheme.strikeUpListMarqueeBoxDecoration,//
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: viewModel.scrollController,
        scrollDirection: Axis.vertical,
        itemCount: viewModel.playList.length,
        itemExtent: viewModel.height,
        itemBuilder: (context, index) {
          return viewModel.playList[index];
        },
      ),
    );
  }

  getTvData() {
    webSocketUtil.onWebSocketListen(
      functionObj: WsParamsReq.accountOnTV,
      onReceiveData: (res) {
        final tvData = WsAccountOnTVRes.fromJson(res.resultMap);
        String? fromUserAvatar = (tvData.fromUserAvatar != null)? tvData.fromUserAvatar : '';
        viewModel.addTvData(tvData.fromUserNickName, tvData.toUserNickName, tvData.giftName, tvData.duration, fromUserAvatar ?? '', tvData.fromUserGender, tvData.amount ?? 0);
        /// TODO: 資料開始
      });
  }
}
