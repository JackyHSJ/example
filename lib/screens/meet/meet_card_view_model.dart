

import 'dart:convert';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/ws_res/greet/ws_greet_module_list_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_fate_recommend_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/chatroom/chatroom_viewmodel.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/task_manager/task_queue_model.dart';
import 'package:frechat/system/util/real_person_name_auth_util.dart';
import 'package:frechat/system/task_manager/task_manager.dart';

class MeetCardViewModel {
  MeetCardViewModel({required this.ref, required this.setState, required this.tickerProvider});
  WidgetRef ref;
  ViewChange setState;
  TickerProvider tickerProvider;

  String backgroundImg = '';

  final List<String> backgroundImgList = [
    'assets/meet_card/meet_card_background_1.png',
    'assets/meet_card/meet_card_background_2.png',
    'assets/meet_card/meet_card_background_3.png',
    'assets/meet_card/meet_card_background_4.png',
    'assets/meet_card/meet_card_background_5.png',
    'assets/meet_card/meet_card_background_6.png',
    'assets/meet_card/meet_card_background_7.png',
    'assets/meet_card/meet_card_background_8.png',
    'assets/meet_card/meet_card_background_9.png',
    'assets/meet_card/meet_card_background_10.png',
    'assets/meet_card/meet_card_background_11.png',
  ];
  
  AnimationController? _animationController;
  Animation<Offset>? slideAnimation;

  final Random random = Random();
  late TaskManager _taskManager;

  late Function() onShowRechargeDialog;
  late Function() onShowRealPersonDialog;

  void init({
    required Function() onShowRechargeDialog,
    required Function() onShowRealPersonDialog,
  }) {
    this.onShowRechargeDialog = onShowRechargeDialog;
    this.onShowRealPersonDialog = onShowRealPersonDialog;

    _taskManager = TaskManager();
    _getRandomBackgroundImg();
    _initAnimationController();
  }

  void _initAnimationController() {
    _animationController ??= AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 500), // 调整动画时长
    );

    if(_animationController != null) {
      _initSlideAnimation(_animationController!);
    }
  }

  void _initSlideAnimation(AnimationController animationController) {
    if(slideAnimation != null) {
      return;
    }

    final Animation<double> curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );

    slideAnimation = Tween<Offset>(
      /// 開始位置
      begin: const Offset(0.0, 0.0),
      /// 结束位置
      end: const Offset(0.0, -2.0),
    ).animate(curvedAnimation);
  }

  void _disposeAnimationController() {
    if(_animationController == null) {
      return ;
    }

    _animationController?.dispose();
    _animationController = null;
  }

  void dispose() {
    _disposeAnimationController();
    // slideAnimation = null;
  }

  void _getRandomBackgroundImg() {
    backgroundImg = backgroundImgList[random.nextInt(backgroundImgList.length)];
  }

  Future<void> pressLike(FateListInfo fateListInfo, {
    required Function() onStartMask,
    required Function() onStopMask,
  }) async {
    onStartMask();
    await _animationController?.forward();
    await _strikeUp(fateListInfo);
    dispose();
    onStopMask();
  }

  Future<void> pressCancel({
    required Function() onStartMask,
    required Function() onStopMask,
  }) async {
    onStartMask();
    await _animationController?.forward();
    dispose();
    onStopMask();
  }

  Future<void> _strikeUp(FateListInfo fateListInfo) async {
    final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    final num realPersonAuth = ref.read(userInfoProvider).memberInfo!.realPersonAuth ?? 0;
    final num realNameAuth = ref.read(userInfoProvider).memberInfo!.realNameAuth ?? 0;
    final String authResult = await RealPersonNameAuthUtil.needBothAuth(gender, realPersonAuth, realNameAuth);
    /// 判斷是否有真人與實名認證
    if (authResult != ResponseCode.CODE_SUCCESS) {
      onShowRealPersonDialog();
      return;
    }
    _taskManager.enqueueTask(
        task: TaskQueueModel(
            userName: fateListInfo.userName ?? '',
            taskFunction: () => _strikeUpReq(userName: fateListInfo.userName ?? '')
        ),
        onTaskQueueAdd: () {},
        onTaskQueueDone: () {}
    );
  }

  Future<void> _strikeUpReq({required String userName}) async {
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    await ref.read(strikeUpProvider).strikeUp(
        userName: userName,
        onSuccess: (searchListInfo) {
          final isGirl = ref.read(userInfoProvider).memberInfo?.gender == 0;
          if (isGirl) {
            _sendCommonPhrases(currentContext, searchListInfo: searchListInfo);
          } else {
            _sendPickUpPhrases(currentContext, searchListInfo: searchListInfo);
          }
          if (currentContext.mounted) {
            final String label = isGirl ? '心动' : '搭讪';
            final String name = searchListInfo?.remark ?? searchListInfo?.roomName ?? '';
            BaseViewModel.showToast(currentContext, '您已$label $name！');
          }
        },
        onFail: (msg) {
          // 儲值不足彈窗
          if (msg ==  ResponseCode.CODE_COIN_BALANCE_NOT_ENOUGH){
            onShowRechargeDialog();
          }
          // 真人、實名彈窗
          if(msg == ResponseCode.CODE_REAL_PERSON_VERIFICATION_UNDER_REVIEW || msg == ResponseCode.CODE_REAL_NAME_UNDER_REVIEW){
            onShowRealPersonDialog();
          }
        });

    _taskManager.processQueue();
  }

  ///搭訕常用語
  Future<void> _sendPickUpPhrases(BuildContext context, {SearchListInfo? searchListInfo}) async {
    final ChatRoomViewModel viewModel = ChatRoomViewModel(ref: ref, setState: setState, context: context);
    final String data = await rootBundle.loadString('assets/txt/strike_up_list_pick_up_phrases.txt');
    final List<String> list = const LineSplitter().convert(data);
    final Random random = Random();
    // Api 3-1
    await viewModel.sendTextMessage(
      searchListInfo: searchListInfo,
      message: list[random.nextInt(list.length)],
      contentType: 3,
      isStrikeUp: true,
    );
    setState((){});
  }

  ///心動常用語(女性)
  Future<void> _sendCommonPhrases(BuildContext context, {SearchListInfo? searchListInfo}) async {
    /// 判斷是否有招呼與設置
    final List<GreetModuleInfo> greetList = ref.read(userInfoProvider).greetModuleList?.list ?? [];
    final ChatRoomViewModel viewModel = ChatRoomViewModel(ref: ref, setState: setState, context: context);

    // 取得正在使用的招呼語 List
    final List<GreetModuleInfo> girlGreet = greetList.where((greet) {
      final authType = CertificationModel.getGreetType(authNum: greet.status ?? 0);
      return CertificationType.using == authType;
    }).toList();

    /// 無設置招呼語
    if (girlGreet.isEmpty) {
      String data = await rootBundle.loadString('assets/txt/strike_up_list_common_phrases.txt');
      List<String> list = const LineSplitter().convert(data);
      Random random = Random();
      // Api 3-1
      await viewModel.sendTextMessage(
        searchListInfo: searchListInfo,
        message: list[random.nextInt(list.length)],
        isStrikeUp: true,
        contentType: 3,
      );
      setState((){});
      return;
    }

    /// 待補上
    if (girlGreet.first.greetingPic != null) {
      await viewModel.sendImageMessage(
        searchListInfo: searchListInfo,
        unRead: 1,
        isStrikeUp: true,
        imgUrl: girlGreet.first.greetingPic,
      );
    }

    if (girlGreet.first.greetingText != null) {
      await viewModel.sendTextMessage(
        searchListInfo: searchListInfo,
        message: girlGreet.first.greetingText,
        isStrikeUp: true,
      );
    }

    if (girlGreet.first.greetingAudio != null) {
      await viewModel.sendVoiceMessage(
        searchListInfo: searchListInfo,
        unRead: 1,
        isStrikeUp: true,
        audioUrl: girlGreet.first.greetingAudio?.filePath,
      );
    }

    setState((){});
  }
}