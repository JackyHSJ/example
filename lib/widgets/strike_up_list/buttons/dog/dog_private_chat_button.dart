import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';

class DogPrivateChatButton extends StatefulWidget {
  const DogPrivateChatButton({super.key,required this.onTap,required this.width,required this.height});
  final double width;
  final double height;
  final Function() onTap;
  @override
  State<DogPrivateChatButton> createState() => _DogPrivateChatButtonState();
}

class _DogPrivateChatButtonState extends State<DogPrivateChatButton> {
  @override
  Widget build(BuildContext context) {

    return CommonButton(
      btnType: CommonButtonType.custom,
      cornerType: CommonButtonCornerType.custom,
      isEnabledTapLimitTimer: true,
      clickLimitTime: 2,
      customWidget: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(borderRadius:BorderRadius.circular(widget.width),boxShadow: [BoxShadow(color:Color(0xFFD1D1D1), blurRadius: 10.w)],),
        child: Image(image: AssetImage('assets/dog/private_chat_btn.png')),
      ),
      onTap: () => widget.onTap.call(),
    );
  }
}
