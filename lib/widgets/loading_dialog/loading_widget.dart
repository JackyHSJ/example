import 'package:flutter/material.dart';
import 'package:frechat/widgets/loading_dialog/dialog_router.dart';
import 'package:lottie/lottie.dart';

//Loading圖示
class Loading {
  static void show(BuildContext context, String text) {
    Navigator.of(context).push(DialogRouter(LoadingDialog(text)));
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class LoadingDialog extends Dialog {
  final String text;

  const LoadingDialog(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    double width = 75;
    double height = 85;
    if (text.length > 3) {
      width = text.length * 15;
      height = height * width / 75;
    }
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: SizedBox(
          width: width,
          height: height,
          // padding:
          child: FractionallySizedBox(
            widthFactor: 1.0, // 设置宽度充满父容器
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.5),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Lottie.asset('assets/json/dot_loading.json',
                        width: 50, height: 50),
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
