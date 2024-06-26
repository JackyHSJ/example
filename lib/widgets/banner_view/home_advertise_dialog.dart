import 'package:flutter/material.dart';

/// 廣告對話框
class HomeAdvertiseDialog extends StatelessWidget {

  //直接跳這個選擇對話框給使用
  static Future show(
      BuildContext context, {
        bool barrierDismissible = false,
        Key? key
      }) async {
    //Use showDialog here.
    await showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) {
        return HomeAdvertiseDialog(key: key);
      },
    );
  }

  const HomeAdvertiseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset('assets/strike_up_list/advertise.png')),
          const SizedBox(height: 16,),
          InkWell(
            borderRadius: BorderRadius.circular(32),
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: kMinInteractiveDimension,
              height: kMinInteractiveDimension,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.5), // 黑色半透明背景
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white, // 白色不透明的图标颜色
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
