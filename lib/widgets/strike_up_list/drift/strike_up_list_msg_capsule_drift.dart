
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/database/model/chat_message_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/widgets/strike_up_list/drift/strike_up_list_msg_capsule_drift_view_model.dart';
import 'package:flutter_screenutil/src/size_extension.dart';

class StrikeUpListMsgCapsuleDrift extends ConsumerStatefulWidget {
  const StrikeUpListMsgCapsuleDrift({super.key, required this.chatUserModel});

  final ChatUserModel chatUserModel;

  @override
  ConsumerState<StrikeUpListMsgCapsuleDrift> createState() => _StrikeUpListMsgCapsuleDriftState();
}

class _StrikeUpListMsgCapsuleDriftState extends ConsumerState<StrikeUpListMsgCapsuleDrift> {
  late StrikeUpListMsgCapsuleDriftViewModel viewModel;
  ChatUserModel get chatMessageModel => widget.chatUserModel;

  @override
  void initState() {
    viewModel = StrikeUpListMsgCapsuleDriftViewModel(ref: ref, setState: setState);
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
    return Consumer(builder: (context, ref, _){
      // final ChatUserModel senderInfo = viewModel.getSenderInfo(context, chatMessageModel: chatMessageModel);
      // final String msg = viewModel.checkAndDecodeContentForCallMsg(chatMessageModel: chatMessageModel);
      return customListTile(
        leading: _buildAvatar(widget.chatUserModel),
        title: Text(
          widget.chatUserModel.roomName ?? widget.chatUserModel.userName ?? '',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          widget.chatUserModel.recentlyMessage ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 10, color: Colors.white),
        ),
      );
    });
  }

  _buildAvatar(ChatUserModel senderInfo) {
    final String avatar = senderInfo.roomIcon ?? '';
    final num gender = ref.read(userInfoProvider).memberInfo?.gender == 0 ? 1 : 0;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: (avatar == '')
          ? AvatarUtil.defaultAvatar(gender, size: 32.w)
          : AvatarUtil.userAvatar(
              HttpSetting.baseImagePath + senderInfo.roomIcon!,
              size: 32.w,
            ),
    );
  }

  //待確認是否調整 StrikeUpList 下的 customListTile 與之共用
  Widget customListTile({
    required Widget? leading,
    required Widget? title,
    required Widget? subtitle,
  }) {
    return SizedBox(
      height: 40.w, // 設定自定義tile的期望高度
      child: Row(
        children: [
          if (leading != null) leading,
          const SizedBox(width: 2),
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) title,
              if (subtitle != null) subtitle,
            ],
          )),
        ],
      ),
    );
  }
}
