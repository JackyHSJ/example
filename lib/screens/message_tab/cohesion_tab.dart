import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/message_tab/message_list_item.dart';
import 'package:frechat/screens/message_tab/message_tab_viewmodel.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/provider/chat_block_model_provider.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/buttons/gradient_button.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:uuid/uuid.dart';

/// 訊息列表(亲密度页签)
class CohesionTab extends ConsumerStatefulWidget {
  final TabController? tabController;
  final ScrollController? scrollController;

  CohesionTab({super.key, this.tabController, this.scrollController});

  @override
  ConsumerState<CohesionTab> createState() => _ChatRoomTabState();
}

class _ChatRoomTabState extends ConsumerState<CohesionTab> {
  late MessageTabViewModel viewModel;

  @override
  void initState() {
    viewModel = MessageTabViewModel(ref: ref, setState: setState, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        List<ChatUserModel> userModel = [];
        /// chatUserModel & chatBlockModel只要內容有更新就會泫染畫面
        final chatUserModel = ref.watch(chatUserModelNotifierProvider);
        final chatBlockModel = ref.watch(chatBlockModelNotifierProvider);
        /// 判斷 最新訊息不為空 && 是否為blockUser
        userModel = chatUserModel.where((info) {
          final bool isNotEmpty = info.recentlyMessage?.isNotEmpty ?? false;
          /// 檢查 黑名單內用戶與列表內做比對移除、當chatBlockModel則直接給予true過
          final bool isNotBlock = chatBlockModel.any((blockUser) => blockUser.userName != info.userName) || chatBlockModel.isEmpty;
          return isNotEmpty && isNotBlock;
        }).toList();
        return cohesionTab(userModel);
      },
    );
  }

  //签密度页签
  Widget cohesionTab(List<ChatUserModel> userModel) {
    List<ChatUserModel> selectList = userModel.where((info) => info.cohesionLevel! >= 2 && info.recentlyMessage!.isNotEmpty).toList();
    if (selectList.isNotEmpty) {
      List<ChatUserModel> sortList = viewModel.sortChatUsers(selectList);
      return ListView.builder(
        key: Key(const Uuid().v4()),
        shrinkWrap: true, // 让 ListView 根据内容自适应高度
        itemCount: sortList.length,
        controller: widget.scrollController,
        itemBuilder: (context, index) {
          ChatUserModel chatUserModel = sortList[index];
          SearchListInfo? searchListInfo = viewModel.transferChatUserModelToSearchListInfo(chatUserModel);
          return MessageListItem(
              isSystem: (searchListInfo!.userName == 'java_system') ? true : false,
              searchListInfo: searchListInfo,
              recentlyMessage: chatUserModel.recentlyMessage,
              unRead: (chatUserModel.unRead ?? 0).toInt(),
              isPinTop: chatUserModel.pinTop,
              points: chatUserModel.points,
              timeStamp: (chatUserModel.timeStamp ?? 0).toInt(),
              sendStatus: chatUserModel.sendStatus ?? 1,
          );
        },
      );
    } else {
      return emptyTabContent(MessageTabType.cohesion);
    }
  }

  //空內容頁籤內容
  Widget emptyTabContent(MessageTabType type) {
    String contentTitle = "您目前暂无消息纪录";
    String contentSubtitle = "快去聊天吧";
    bool showButton = true;
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppImageTheme appImageTheme = theme.getAppImageTheme;
    final AppLinearGradientTheme appLinearGradientTheme = theme.getAppLinearGradientTheme;
    final AppTextTheme appTextTheme = theme.getAppTextTheme;
    String image = appImageTheme.imageMessageEmpty;
    if (type == MessageTabType.cohesion) {
      contentTitle = "亲密度等级≥2的亲密关系会在这里显示哦";
      contentSubtitle = '立即聊天，遇见亲密的Ta';
      showButton = true;
      image = appImageTheme.imageCohesionEmpty;
    } else if (type == MessageTabType.call) {
      contentTitle = '暂无通话纪录';
      contentSubtitle = '快去通话吧';
      showButton = false;
      image = appImageTheme.imageCallEmpty;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          width: 150.w,
          height: 150.w,
          image: AssetImage(image),
        ),
        Container(
          margin: EdgeInsets.only(top: 14.h),
          child: Text(
            contentTitle,
            style: appTextTheme.messageTabEmptyTitleTextStyle,
          ),
        ),
        Text(
          contentSubtitle,
          style: appTextTheme.messageTabEmptySubTitleTextStyle,
        ),
        SizedBox(height: 24.h),
        (showButton)
        ? CommonButton(
            btnType: CommonButtonType.text,
            cornerType: CommonButtonCornerType.circle,
            isEnabledTapLimitTimer: false,
            width: 148.w,
            height: 44.h,
            text: '去聊天',
            textStyle: appTextTheme.buttonPrimaryTextStyle,
            colorBegin: appLinearGradientTheme.buttonPrimaryColor.colors[0],
            colorEnd: appLinearGradientTheme.buttonPrimaryColor.colors[1],
            onTap: () {
              if (type == MessageTabType.cohesion) {
                widget.tabController!.animateTo(0);
              } else {
                ///Todo 如何跳轉
                // Navigator.pop(context);
              }
            })
            : Container()
      ],
    );
  }
}
