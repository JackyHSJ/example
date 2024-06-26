import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_list_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_strike_up_req.dart';
import 'package:frechat/models/ws_res/greet/ws_greet_module_list_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_strike_up_res.dart';
import 'package:frechat/screens/chatroom/chatroom.dart';
import 'package:frechat/screens/chatroom/chatroom_viewmodel.dart';
import 'package:frechat/screens/profile/certification/personal_certification.dart';
import 'package:frechat/screens/profile/certification/real_person/personal_certification_real_person.dart';
import 'package:frechat/screens/user_info_view/user_info_view.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/extension/chat_user_model.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/task_manager/task_queue_model.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/system/util/dialog_util.dart';
import 'package:frechat/system/util/real_person_name_auth_util.dart';
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/system/task_manager/task_manager.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/dialog/real_person_verify_dialog.dart';
import 'package:frechat/widgets/shared/tag_text.dart';
import 'package:frechat/widgets/strike_up_list/buttons/original/strike_up_list_love_button.dart';
import 'package:frechat/widgets/strike_up_list/frechat/frechat_strike_up_list_avatar.dart';
import 'package:frechat/widgets/strike_up_list/frechat/frechat_strike_up_list_personal_info.dart';
import 'package:frechat/widgets/strike_up_list/frechat/frechat_tag_text.dart';
import 'package:frechat/widgets/strike_up_list/strike_up_list_avatar.dart';
import 'package:frechat/widgets/strike_up_list/strike_up_list_extension.dart';
import 'package:frechat/widgets/strike_up_list/strike_up_list_member_card_view_model.dart';
import 'package:frechat/widgets/strike_up_list/strike_up_list_personal_info.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

import '../../../models/ws_res/member/ws_member_fate_recommend_res.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

class FrechatStrikeUpListCard extends ConsumerStatefulWidget {
  final FateListInfo fateListInfo;

  //Option: 如果搭訕過後有 roomId 的狀況可以帶在這表明這個人已經搭訕過。
  ///TODO 優化：不需要刪除此參數
  final num? roomId;

  final TaskManager taskManager;

  const FrechatStrikeUpListCard({
    super.key,
    required this.fateListInfo,
    this.roomId,
    required this.taskManager,
  });

  @override
  ConsumerState<FrechatStrikeUpListCard> createState() => _StrikeUpListMemberCardState();
}

class _StrikeUpListMemberCardState extends ConsumerState<FrechatStrikeUpListCard>  {

  late StrikeUpListMemberCardViewModel viewModel;

  //這是搭訕過後的結果資料, 注意這會影響進入聊天室跟按鈕 isChat
  TaskManager get taskManager => widget.taskManager;

  late AppTheme _theme;
  late AppTextTheme _appTextTheme;


  @override
  void initState() {
    super.initState();
    viewModel = StrikeUpListMemberCardViewModel(ref: ref, setState: setState, taskManager: taskManager);
    viewModel.init();
  }

  @override
  void didUpdateWidget(covariant FrechatStrikeUpListCard oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  /// 真人認證彈窗
  void _showRealPersonDialog(){
    final currentContext = BaseViewModel.getGlobalContext();
    DialogUtil.popupRealPersonDialog(theme:_theme,context: currentContext, description: '您还未通过真人认证与实名认证，认证完毕后方可传送心动 / 搭讪');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: 94,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _memberInfoWidget(),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () {
                BaseViewModel.pushPage(context, UserInfoView(
                  fateListInfo: widget.fateListInfo,
                  displayMode: DisplayMode.strikeUp,
                ));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start, // 灰色標籤靠左
                mainAxisSize: MainAxisSize.max,
                children: [
                  _memberInfoContentTitle(),
                  _memberInfoContentSubTitle(),
                  _memberInfoContentMessage(),
                ],
              ),
            )
          ),
          const SizedBox(width: 8),
          _strikeUpListLoveButton(),
        ],
      ),
    );
  }

  /// 用戶資訊
  Widget _memberInfoWidget(){
    return InkWell(
      onTap: () {
        BaseViewModel.pushPage(context, UserInfoView(
          fateListInfo: widget.fateListInfo,
          displayMode: DisplayMode.strikeUp,
        ));
      },
      child: Row(
        children: [
          _memberInfoAvatar(),
          // SizedBox(width: 9),
          // _memberInfoContent(),
        ],
      ),
    );
  }

  /// 用戶資訊 - 頭像
  Widget _memberInfoAvatar(){
    return FrechatStrikeUpListAvatar(fateListInfo: widget.fateListInfo,);
  }

  /// 用戶資訊 - 內容
  Widget _memberInfoContent(){
    return Container(
      width: 170,
      height: 75,
      margin: EdgeInsets.symmetric(horizontal: 9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start, // 灰色標籤靠左
        mainAxisSize: MainAxisSize.max,
        children: [
          _memberInfoContentTitle(),
          _memberInfoContentSubTitle(),
          _memberInfoContentMessage(),
        ],
      ),
    );
  }

  /// 用戶資訊 - 內容 - 標題（名稱/性別/認證/VIP）
  Widget _memberInfoContentTitle() {
    String nickName = '';
    if(widget.fateListInfo.nickName != null){
      if(widget.fateListInfo.nickName!.isNotEmpty){
        nickName = widget.fateListInfo.nickName!;
      }else{
        nickName = widget.fateListInfo.userName!;
      }
    }else{
      nickName = widget.fateListInfo.userName!;

    }

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text(
            nickName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xff222222),
            ),
          ),
          const SizedBox(width: 3),
          FrechatStrikeUpListPersonalInfo(fateListInfo: widget.fateListInfo,),
        ],
      ),
    );
  }

  /// 用戶資訊 - 內容 - 副標題（地區/距離/體重/公司）
  Widget _memberInfoContentSubTitle() {

    // final String hometown = widget.fateListInfo?.hometown ?? '';
    final num? height = widget.fateListInfo?.height;
    // final num? weight = widget.fateListInfo?.weight;
    final String occupation = widget.fateListInfo?.occupation ?? '';
    final List<String> jobs = occupation.split(' ');
    final num age = widget.fateListInfo?.age ?? 0;

    List<Widget> tagList = [];

    tagList.add(FrechatTagText(text: '${age}岁',));

    if (occupation.trim().isNotEmpty) {
      tagList.add(_buildDivider());
      tagList.add(FrechatTagText(text: '${jobs[1]}',));
    }

    if (height != null && height != 0) {
      tagList.add(_buildDivider());
      tagList.add(FrechatTagText(text: '${height}cm',));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tagList,
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 1,
      height: 14,
      color: Color(0xff222222),
    );
  }

  /// 用戶資訊 - 內容 - 座右銘
  Widget _memberInfoContentMessage() {

    String selfIntroduction = widget.fateListInfo.selfIntroduction ?? '';
    if (selfIntroduction.isEmpty) selfIntroduction = '这个用户还在火星，请呼喊他的名字';
    selfIntroduction = selfIntroduction.replaceAll("\n", " ");

    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        selfIntroduction.trim(),
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xff222222)
        ),
      ),
    );
  }

  /// 搭訕/心動/私聊 按鈕
  Widget _strikeUpListLoveButton(){
    WsMemberInfoRes? memberInfo = ref.read(userInfoProvider).memberInfo;
    num? gender;
    if (memberInfo != null) {
      gender = memberInfo.gender!;
    }


    return Consumer(builder: (context,ref,_){
      final bool isAlreadyStrikeUp =  ref.watch(strikeUpProvider).isAlreadyStrikeUp(userName: widget.fateListInfo.userName??'');
      return StrikeUpListLoveButton(
        isChat: isAlreadyStrikeUp,
        gender: gender,
        onCheck: () {
          final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
          final num realPersonAuth = ref.read(userInfoProvider).memberInfo!.realPersonAuth ?? 0;
          final num realNameAuth = ref.read(userInfoProvider).memberInfo!.realNameAuth ?? 0;
          String authResult = RealPersonNameAuthUtil.needBothAuth(gender, realPersonAuth, realNameAuth);
          /// 判斷是否有真人與實名認證
          if (authResult != ResponseCode.CODE_SUCCESS) {
            _showRealPersonDialog();
            return false;
          }
          return true;
        },
        onStrikeUpPress: () => taskManager.enqueueTask(
            task: TaskQueueModel(
              userName: widget.fateListInfo.userName ?? '',
              taskFunction: () => viewModel.strikeUp(userName: widget.fateListInfo.userName ?? ''),
            ),
            onTaskQueueAdd: () {},
            onTaskQueueDone: () {}
        ),
        onChatPress: () async {
          SearchListInfo? searchListInfo = await viewModel.openChatRoom(userName:  widget.fateListInfo.userName ??'');
          if (searchListInfo != null && mounted) {
            BaseViewModel.pushPage(context, ChatRoom(unRead: 0, searchListInfo: searchListInfo,));
          }
        }
      );
    });
  }

  /// 副標題標籤
  Widget _subTitleTag(String txt) {
    return TagText(text: txt.trim(),);
  }



}
