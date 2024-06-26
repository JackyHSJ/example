import 'package:flutter/material.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

///by Benson
class UserInfoCapsuleBox extends StatelessWidget {
  final String title;
  final String? txt;
  final double? width;
  final double height;
  final double? fontSize;
  final Color? color;
  final List<Color>? colors;
  final Alignment? begin;
  final Alignment? end;
  final BorderRadius? borderRadius;
  const UserInfoCapsuleBox({
    super.key,
    required this.title,
    this.txt,
    this.width,
    required this.height,
    this.fontSize,
    this.color,
    this.colors,
    this.begin,
    this.end,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(2, 4, 2, 4),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(48),
              color: color,
              gradient: colors == null
                  ? null
                  : AppColors.pinkLightGradientColors,
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textFormBlack,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48),
        gradient: const LinearGradient(
          colors: [Color.fromRGBO(235, 93, 142, 1), Color.fromRGBO(240, 138, 191, 1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'data',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
/*
      child: customListTile(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(48),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/strike_up_list/demo_msg_avatar.png',
                width: 36,
                height: 36,
              ),
            ),
          ),
        ),
        title: const Text(
          '小野貓',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text(
          '我想要罐罐...',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
      ),
*/
    );
  }
  */
}
