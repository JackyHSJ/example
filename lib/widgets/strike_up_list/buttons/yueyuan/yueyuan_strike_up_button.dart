import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
class YueyuanStrikeUpButton extends StatefulWidget {
  const YueyuanStrikeUpButton({super.key,required this.onTap,required this.width,required this.height});
  final double width;
  final double height;
  final Function() onTap;
  @override
  State<YueyuanStrikeUpButton> createState() => _YueyuanStrikeUpButtonState();
}

class _YueyuanStrikeUpButtonState extends State<YueyuanStrikeUpButton> {
  @override
  Widget build(BuildContext context) {
    return CommonButton(
      btnType: CommonButtonType.custom,
      cornerType: CommonButtonCornerType.custom,
      isEnabledTapLimitTimer: true,
      clickLimitTime: 9999, // 避免重複打搭訕，所以設 9999 秒
      customWidget: Container(
        width: widget.width,
        height: widget.height,
        // decoration: BoxDecoration(borderRadius:BorderRadius.circular(widget.width),boxShadow: [BoxShadow(color:Color(0xFFD1D1D1), blurRadius: 10.w)],),
        child: Image(image: AssetImage('assets/yueyuan/strike_up_btn.png')),
      ),
      onTap: () => widget.onTap.call(),
    );
  }


}