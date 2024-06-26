import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class StrikeUpListLoveButton extends ConsumerStatefulWidget {
  final bool isChat;
  final num? gender;
  final double? width;
  final double? height;


  final Function() onStrikeUpPress;
  final Function() onChatPress;
  final Function()? onCheck;

  const StrikeUpListLoveButton({
    super.key,
    this.isChat = false,
    required this.gender,
    this.width,
    this.height,
    required this.onStrikeUpPress,
    required this.onChatPress,
    this.onCheck,
  });

  @override
  ConsumerState<StrikeUpListLoveButton> createState() =>
      _StrikeUpListLoveButtonState();
}

class _StrikeUpListLoveButtonState extends ConsumerState<StrikeUpListLoveButton> {

  late AppTheme _theme;
  double get width =>widget.width ?? 67.w;
  double get height =>widget.height ?? 32.h;

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    Widget chatBtn = privateChatButton();
    Widget heard = heartbeatButton(widget.gender);
    return Row(
      children: [
        Visibility(visible:widget.isChat==true,child: chatBtn),
        Visibility(visible:widget.isChat==false,child: heard)
      ],
    );
    return widget.isChat ? chatBtn : heard;
  }

  ///私聊
  Widget privateChatButton() {
    return _theme.getAppButtonTheme(width: width, height:height, onTap: () => widget.onChatPress.call())
            .privateChatButton;
  }

  ///心動/搭訕
  Widget heartbeatButton(num? gender) {
    return gender == 0
        ? _theme.getAppButtonTheme(width: width, height: height, onCheck: () => widget.onCheck?.call() ,onTap: () => widget.onStrikeUpPress.call())
                .heartbeatButton
        : _theme.getAppButtonTheme(width: width, height: height, onCheck: () => widget.onCheck?.call() , onTap: () => widget.onStrikeUpPress.call())
                .strikeUpButton;
  }
}
