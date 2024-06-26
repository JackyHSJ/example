
import 'package:flutter/material.dart';
import 'package:frechat/widgets/banner_view/banner_view.dart';

class BannerViewDialog extends StatefulWidget {

  static Future show(
      BuildContext context, {
        bool barrierDismissible = false,
        Function()? onClose,
        Key? key
      }) async {
    //Use showDialog here.
    await showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) {
        return BannerViewDialog(key: key,onClose: onClose,);
      },
    );
  }
  final Function()? onClose;

  const BannerViewDialog({super.key, this.onClose});


  @override
  State<BannerViewDialog> createState() => _BannerViewDialogState();
}

class _BannerViewDialogState extends State<BannerViewDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: BannerView(
              locatedPageFilter: 1,
              aspectRatio: 1,
            ),
          ),

          const SizedBox(height: 16,),
          InkWell(
            borderRadius: BorderRadius.circular(32),
            onTap: () {
              Navigator.pop(context);
              if(widget.onClose !=null){
                widget.onClose?.call();
              }
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



// class BannerViewDialog extends StatelessWidget {
//
//   //直接跳這個選擇對話框給使用
//
//
//   const BannerViewDialog({super.key , required onClose,});
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: BannerView(
//               locatedPageFilter: 1,
//               aspectRatio: 1,
//             ),
//           ),
//
//           const SizedBox(height: 16,),
//           InkWell(
//             borderRadius: BorderRadius.circular(32),
//             onTap: () {
//               if()
//               Navigator.pop(context);
//             },
//             child: Container(
//               width: kMinInteractiveDimension,
//               height: kMinInteractiveDimension,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.black.withOpacity(0.5), // 黑色半透明背景
//               ),
//               child: const Icon(
//                 Icons.close,
//                 color: Colors.white, // 白色不透明的图标颜色
//                 size: 32,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
