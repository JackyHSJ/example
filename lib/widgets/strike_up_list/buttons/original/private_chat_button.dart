import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';

class PrivateChatButton extends StatefulWidget {
  const PrivateChatButton({super.key,required this.onTap,required this.width,required this.height});
  final double width;
  final double height;
  final Function() onTap;
  @override
  State<PrivateChatButton> createState() => _PrivateChatButtonState();
}

class _PrivateChatButtonState extends State<PrivateChatButton> {
  @override
  Widget build(BuildContext context) {

    return CommonButton(
      btnType: CommonButtonType.custom,
      cornerType: CommonButtonCornerType.custom,
      isEnabledTapLimitTimer: true,
      clickLimitTime: 2,
      customWidget: const SizedBox(
        width: 67,
        height: 32,
        child: Image(image: AssetImage('assets/strike_up_list/frechat/icon_strike_up_chat.png')),
      ),
      onTap: () => widget.onTap.call(),
    );
  }
}
