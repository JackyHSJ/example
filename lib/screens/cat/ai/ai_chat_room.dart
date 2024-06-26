

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/cat/ai/ai_chat_room_view_model.dart';
import 'package:frechat/screens/cat/ai/cat_chat_message.dart';
import 'package:frechat/screens/chatroom/chatroom_viewmodel.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/divider.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/main_textfield.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class AiChatRoom extends ConsumerStatefulWidget {
  const AiChatRoom({super.key});

  @override
  ConsumerState<AiChatRoom> createState() => _AiChatRoomState();
}

class _AiChatRoomState extends ConsumerState<AiChatRoom> {
  late AiChatRoomViewModel viewModel;
  late AppTheme _theme;
  late AppColorTheme appColorTheme;

  @override
  void initState() {
    viewModel = AiChatRoomViewModel(setState: setState, ref: ref);
    viewModel.init();
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final paddingHeight = UIDefine.getStatusBarHeight() + UIDefine.getAppBarHeight();
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appColorTheme = _theme!.getAppColorTheme;
    final bool isKeyboardEnable = viewModel.textFocusNode.hasFocus;
    final paddingBottom = isKeyboardEnable == true
      ? UIDefine.getNavigationBarHeight()
      : UIDefine.getNavigationBarHeight() + WidgetValue.bottomPadding + WidgetValue.verticalPadding;
    return MainScaffold(
      padding: EdgeInsets.only(top: paddingHeight, bottom: paddingBottom),
      isFullScreen: false,
      needSingleScroll: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: appColorTheme.baseBackgroundColor,
      appBar: MainAppBar(
        theme: _theme,
        title: 'AI Chat',
        backgroundColor: appColorTheme.appBarBackgroundColor,
      ),
      floatingActionButton: textFieldAndRecordWidget(),
      child: Column(
        children: [
          _initChatOption(),
          mainWidget(),
          // textFieldAndRecordWidget(),
        ],
      ),
    );
  }

  _initChatOption() {
    return Padding(
      padding: EdgeInsets.only(top: WidgetValue.verticalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildAvatar(),
          Container(
            width: UIDefine.getWidth()/ 1.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(WidgetValue.btnRadius),
              color: AppColors.btnLightGrey,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 1,
                  blurRadius: WidgetValue.btnRadius,
                  offset: Offset(0, WidgetValue.verticalPadding),
                ),
              ],
            ), //
            child: _buildOptionList(),
          )
        ],
      ),
    );
  }

  //主要畫面
  mainWidget() {
    return Padding(
      padding: EdgeInsets.only(bottom: WidgetValue.mainComponentHeight),
      child: CustomList.mainList(
          itemCount: viewModel.chatList.length,
          physics: const NeverScrollableScrollPhysics(),
          child: (context, index) {
            final zimMessage = viewModel.chatList[index];
            final Map<String, dynamic> extendedDataObj = json.decode(zimMessage.extendedData);
            final bool isMe = extendedDataObj['isMe'] ?? false;
            return bubbleMessage(zimMessage: zimMessage, index: index, isMe: isMe);
          }
      ),
    );
  }

  //對話框
  Widget bubbleMessage({
    required ZIMMessage zimMessage,
    required int index,
    required bool isMe
}) {
    return CatChatMessage(
      zimMessage: zimMessage,
      isMe: isMe,
      viewModel: ChatRoomViewModel(ref: ref, context: context),
      index: index,
      showTimeDistinction: true,
      currentAudioIndexNotifier: ValueNotifier<int?>(0),
      currentAudioUrlNotifier: ValueNotifier<String>(''),
      needReplaceTextWithMeow: false,
    );
  }

  //輸入框和錄音
  Widget textFieldAndRecordWidget() {
    return Container(
        color: appColorTheme.chatRoomBottomBackgroundColor,
        padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding, horizontal: 10),
        height: WidgetValue.mainComponentHeight,
        child: Row(
          children: [
            inputTextField(),
            const SizedBox(width: 7),
            iconTextButtonWidget()
          ],
        ));
  }

  // Text Icon
  Widget iconTextButtonWidget() {
    return GestureDetector(
      child: ImgUtil.buildFromImgPath('assets/images/icon_send.png', size: WidgetValue.primaryIcon),
      onTap: () => viewModel.sendMsg(msg: viewModel.textController.text, isMe: true),
    );
  }

  // Text 輸入框
  Widget inputTextField() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        height: double.infinity,
        decoration: const BoxDecoration(
            color: Color.fromRGBO(245, 245, 245, 1),
            borderRadius: BorderRadius.all(Radius.circular(99.0))),
        child: MainTextField(
          contentPaddingLeft: WidgetValue.separateHeight,
          controller: viewModel.textController,
          focusNode: viewModel.textFocusNode,
          hintText: '',
          borderColor: Colors.transparent,
        )
      )
    );
  }

  _buildAvatar() {
    final num myGender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    final num gender = myGender == 0 ? 1 : 0;
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 13,right: 11),
          child: ImgUtil.buildFromImgPath('assets/images/image_cat_container.png', size: 34, fit: BoxFit.fitWidth),
        ),
        ClipOval(
          child: BaseViewModel.maleOrFemaleAvatarWidget(gender, size: 25),
        )
      ],
    );
  }

  _buildOptionList() {
    return CustomList.separatedList(
      separator: MainDivider(color: AppColors.dividerGrey, weight: 2, height: 2),
      physics: const NeverScrollableScrollPhysics(),
      childrenNum: viewModel.optionModelList.length,
      children: (context, index) {
        if(index == 0) {
          return _buildTitle();
        }
        return _buildDes(viewModel.optionModelList[index]);
      });
  }

  _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding, vertical: WidgetValue.verticalPadding),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: AppColors.whiteBackGround,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(WidgetValue.btnRadius),
          topRight: Radius.circular(WidgetValue.btnRadius)
        )
      ),
      child: Text(viewModel.optionTitle, style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  _buildDes(AiChatRoomModel model) {
    return InkWell(
      onTap: () => model.onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
        height: WidgetValue.smallComponentHeight,
        alignment: Alignment.center,
        child: Text(model.title, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}