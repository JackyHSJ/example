// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import 'package:frechat/system/providers.dart';
// import 'package:frechat/system/base_view_model.dart';
// import 'package:frechat/system/repository/response_code.dart';
//
// import 'package:frechat/models/ws_req/mission/ws_mission_get_award_req.dart';
//
//
// class PersonalMissionBonus extends ConsumerStatefulWidget {
//
//   final num target;
//   final String title;
//   final String subTitle;
//   final int count;
//   final int gender;
//
//   const PersonalMissionBonus({
//     super.key,
//     required this.target,
//     required this.title,
//     required this.subTitle,
//     required this.count,
//     required this.gender,
//   });
//
//   @override
//   ConsumerState<PersonalMissionBonus> createState() => _PersonalMissionBonusState();
// }
//
// class _PersonalMissionBonusState extends ConsumerState<PersonalMissionBonus> {
//
//   bool isOpen = false;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     final int gender = widget.gender;
//     final String title = widget.title;
//     final String subTitle = widget.subTitle;
//     final int count = widget.count;
//     final String stageLabel = widget.target < 4 ? '完成新手任务' : '完成每日任务';
//     final String type = gender == 0  ? '积分' : '金币';
//
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         GestureDetector(
//           onTap: () => _openHandler(),
//           child: isOpen ? _buildBonusOpenView(stageLabel, count, type, title, subTitle) : _buildBonusCloseView(),
//         ),
//         GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: _buildCancelButton()
//         )
//       ],
//     );
//   }
//
//   Widget _buildCancelButton(){
//     return Image.asset('assets/strike_up_list/Cancel.png', width: 36, height: 36);
//   }
//
//   Widget _buildBonusCloseView(){
//     return Image.asset('assets/strike_up_list/bonus.png', width: 343, height: 280, fit: BoxFit.contain);
//   }
//
//   Widget _buildBonusOpenView(stageLabel, count, type, title, subTitle){
//     return SizedBox(
//       width: 343,
//       height: 490,
//       child: Stack(
//         children: [
//           Image.asset('assets/strike_up_list/bonus_open.png', width: 343, height: 490, fit: BoxFit.contain),
//           SizedBox(
//               width: double.infinity,
//               child: DefaultTextStyle(
//                 style: const TextStyle(decoration: TextDecoration.none),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 60),
//                     Text('$stageLabel', style: const TextStyle(color: Color(0xFFFFBE3F), fontSize: 18, fontWeight: FontWeight.w700, height: 1.25)),
//                     const SizedBox(height: 12),
//                     Text('+$count', style: const TextStyle(color: Color(0xFFFFBE3F), fontSize: 60, fontWeight: FontWeight.w700, height: 1.13,)),
//                     const SizedBox(height: 12),
//                     Text('$type', style: const TextStyle(color: Color(0xFFFFBE3F), fontSize: 24, fontWeight: FontWeight.w700, height: 1.5)),
//                     const SizedBox(height: 83),
//                     Text('$title', style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 24, fontWeight: FontWeight.w700, height: 1.25)),
//                     const SizedBox(height: 3),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 48, right: 48),
//                       child: Text('$subTitle',
//                           textAlign: TextAlign.center,
//                           softWrap: true,
//                           style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.80), fontSize: 20, fontWeight: FontWeight.w700, height: 1.25)
//                       ),
//                     )
//                   ],
//                 ),
//               )
//           )
//         ],
//       ),
//     );
//   }
//
//   void _openHandler(){
//     if (isOpen) {
//       Navigator.pop(context);
//     } else {
//       _getMissionAward();
//       setState(() => isOpen = true);
//     }
//   }
//
//   Future<void> _getMissionAward() async {
//     String? resultCodeCheck;
//     final reqBody = WsMissionGetAwardReq.create(target: widget.target.toString());
//     await ref.read(missionWsProvider).wsMissionGetAward(reqBody,
//         onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
//         onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));
//
//     setState(() {});
//   }
// }