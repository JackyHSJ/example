import 'package:flutter/material.dart';
import 'check_dialog.dart';

// //彈出真人驗證要求對話框
// Future showRealPersonVerifyDialog(BuildContext context, {
//   Function()? onCancelPress,
//   Function()? onConfirmPress,
//   String? title,
//   String? message
// }) async {
//   //Depend on CheckDialog.
//   await CheckDialog.show(context,
//       titleWidget: Image.asset('assets/strike_up_list/real_person.png'),
//       titleText: title??'真人认证',
//       messageText: message ?? '您还未通过真人认证，认证完毕后方可拨打语音 / 视频通话',
//       showCancelButton: true,
//       cancelButtonText: '考虑一下',
//       confirmButtonText: '立即认证',
//       onCancelPress: onCancelPress,
//       onConfirmPress: onConfirmPress);
// }

//[存參]: 舊東西
// class RealPersonDialog extends StatefulWidget {
//   final Function? function;
//   const RealPersonDialog({super.key, this.function});
//
//   @override
//   State<RealPersonDialog> createState() => _RealPersonDialogState();
// }
//
// class _RealPersonDialogState extends State<RealPersonDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: CheckDialog(
//         //width: 343,
//         height: 270,
//         titleWidget: Image.asset('assets/strike_up_list/real_person.png'),
//         titleText: '真人认证',
//         titleTextStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: AppColors.textFormBlack),
//         messageText: '您还未通过真人认证，认证完毕后方可拨打\n语音 / 视频通话',
//         messageTextStyle: const TextStyle(fontSize: 14.0, color: AppColors.textFormBlack),
//         buttons: [
//           GradientButton(
//             text: '考虑一下',
//             textStyle: const TextStyle(color: Color.fromRGBO(236, 97, 147, 1), fontSize: 14),
//             radius: 24,
//             gradientColorBegin: const Color.fromRGBO(235, 93, 142, 0.1),
//             gradientColorEnd: const Color.fromRGBO(240, 138, 191, 0.1),
//             height: 44,
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           GradientButton(
//             text: '立即认证',
//             textStyle: const TextStyle(color: Colors.white, fontSize: 14),
//             radius: 24,
//             gradientColorBegin: const Color.fromRGBO(235, 93, 142, 1),
//             gradientColorEnd: const Color.fromRGBO(240, 138, 191, 1),
//             height: 44,
//             onPressed: () {
//               Navigator.pop(context);
//               widget.function ?? ();
//               BaseViewModel.pushPage(context, const PersonalCertificationRealPerson());
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
