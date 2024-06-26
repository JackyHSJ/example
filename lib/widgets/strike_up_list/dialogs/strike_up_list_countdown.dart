import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

import '../../../models/ws_req/member/ws_member_point_coin_req.dart';
import '../../../models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/widgets/strike_up_list/strike_up_list_extension.dart';

import '../../../models/ws_res/member/ws_member_point_coin_res.dart';
import '../../../system/providers.dart';
import '../../../system/repository/http_setting.dart';
import '../../shared/color_box.dart';
import '../../shared/buttons/gradient_button.dart';

class StrikeUpListCountdown extends ConsumerStatefulWidget {
  final WsMemberInfoRes tageInfo;
  final Function()? endCall;
  const StrikeUpListCountdown({
    super.key,
    required this.tageInfo,
    this.endCall,
  });

  @override
  ConsumerState<StrikeUpListCountdown> createState() => _StrikeUpListCountdownState();
}

class _StrikeUpListCountdownState extends ConsumerState<StrikeUpListCountdown> {
  int sec = 0;
  Timer? _timer;
  String text = '立即聊天';
  Color gradientColorBegin = AppColors.mainPink;
  Color gradientColorEnd = AppColors.mainPink;
  TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 14);
  String cost = '';

  @override
  void initState() {
    super.initState();
    countdown(40);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/video_dating/videodatingimg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(child: _build()),
        ],
      ),
    );
  }

  Widget _build() {
    Color color = widget.tageInfo.gender == 1 ? const Color.fromRGBO(51, 138, 243, 1) : const Color.fromRGBO(253, 115, 165, 1);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: Container(
              //width: widget.width,
              height: 440, //widget.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text('您的速配对象', style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 20),
                      //頭像
                      _buildAvatar(widget.tageInfo.avatarPath ?? ''),
                      const SizedBox(height: 15),

                      //性別icon、年齡
                      ColorBox(
                        icon: Icon(widget.tageInfo.gender == 1 ? Icons.male : Icons.female, color: Colors.white, size: 12),
                        text: Text(widget.tageInfo.age.toString(), style: const TextStyle(color: Colors.white, fontSize: 10)),
                        height: 16,
                        radius: 48,
                        linearGradient: LinearGradient(
                          colors: [color, color],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(widget.tageInfo.nickName ?? widget.tageInfo.userName ?? '',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textFormBlack), textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (widget.tageInfo.location == null || widget.tageInfo.location == '')
                              ? const SizedBox(height: 16)
                              : _buildGreyBox(widget.tageInfo.location ?? ''),
                          widget.tageInfo.height == null ? const SizedBox(height: 16) : _buildGreyBox(asHeight(widget.tageInfo.height)),
                          widget.tageInfo.weight == null ? const SizedBox(height: 16) : _buildGreyBox(asWeight(widget.tageInfo.weight)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('想要与您速配，快接听把握缘分吧', style: TextStyle(fontSize: 14, color: AppColors.textFormBlack), textAlign: TextAlign.center),
                      const SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
//您的馀额
                          widget.tageInfo.gender == 0 ? _buildBalance() : const SizedBox(),
//通话费率
                          widget.tageInfo.gender == 0 ? _buildRate() : const SizedBox(),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: GradientButton(
                      text: text,
                      textStyle: const TextStyle(color: AppColors.mainDark, fontSize: 14),
                      radius: 24,
                      gradientColorBegin: AppColors.mainLightGrey,
                      gradientColorEnd: AppColors.mainLightGrey,
                      height: 44,
                      onPressed: () {
                        // Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///頭像
  Widget _buildAvatar(String id) {
    String path = HttpSetting.baseImagePath + (widget.tageInfo.avatarPath ?? '');
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48),
        border: Border.all(
          color: widget.tageInfo.gender == 0 ? const Color.fromRGBO(249, 160, 206, 1) : const Color.fromRGBO(51, 138, 243, 1),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: Image.network(
          path,
          errorBuilder: (context, error, stackTrace) {
            // 加載失敗時顯示預設圖片
            return Image.asset('assets/images/default_avatar.png');
          },
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  ///黑底白字框
  Widget _buildGreyBox(String txt) {
    return Row(
      children: [
        ColorBox(
          height: 16,
          radius: 3,
          text: Text(txt, style: const TextStyle(fontSize: 10, color: Colors.white), textAlign: TextAlign.center),
          linearGradient: const LinearGradient(
            colors: [Color.fromRGBO(0, 0, 0, 0.5), Color.fromRGBO(0, 0, 0, 0.5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        const SizedBox(width: 5),
      ],
    );
  }

  ///確認使用速配是男生時的金币餘額
  iniCheck() {
    if (widget.tageInfo.gender == 1) {
      _getGoldCoins_2_8();
    }
  }

  WsMemberPointCoinRes myCoins = WsMemberPointCoinRes();

  ///用戶的 積分, 金币（金币+活動金币）
  _getGoldCoins_2_8() async {
    String resultCodeCheck = '';

    final reqBody = WsMemberPointCoinReq.create();
    try {
      myCoins = await ref.read(memberWsProvider).wsMemberPointCoin(reqBody, onConnectSuccess: (succMsg) {
        // ignore: avoid_print
        print('succMsg:$succMsg');
        resultCodeCheck = succMsg;
      }, onConnectFail: (errMsg) {
        // ignore: avoid_print
        print('errMsg:$errMsg');
        resultCodeCheck = errMsg;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    setState(() {
      myCoins;
    });
  }

  ///您的馀额
  _buildBalance() {
    return Container(
      height: 44,
      width: 148,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(250, 250, 250, 1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '您的馀额',
            style: TextStyle(fontSize: 10, color: AppColors.textFormBlack),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 23, height: 22, child: Image.asset('assets/strike_up_list/ic_coin.png')),
              Text(
                (myCoins.coins ?? 0).toInt().toString(),
                style: const TextStyle(fontSize: 10, color: AppColors.textFormBlack),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///通话费率
  _buildRate() {
    return Container(
      height: 44,
      width: 148,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(250, 250, 250, 1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '通话费率',
            style: TextStyle(fontSize: 10, color: AppColors.textFormBlack),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 23, height: 22, child: Image.asset('assets/strike_up_list/ic_coin.png')),
              Text(
                '$cost / 分钟',
                style: const TextStyle(fontSize: 10, color: AppColors.textFormBlack),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///倒數
  countdown(int s) {
    setState(() {
      sec = s;
      text = '等待对方中  ${sec}s';
      gradientColorBegin = AppColors.mainLightGrey;
      gradientColorEnd = AppColors.mainLightGrey;
      textStyle = const TextStyle(color:AppColors.mainDark, fontSize: 14);
    });
    startTimer();
  }

  ///開始計時
  startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (sec > 0) {
          /*
          if (StrikeUpListExtension.waitingPage) {
            StrikeUpListExtension.waitingPage = false;
            _timer?.cancel();
            Navigator.pop(context);
            Navigator.pop(context);
          }
          */
          sec--;
        } else {
          _timer?.cancel();
          widget.endCall!();
          Navigator.pop(context);
          Navigator.pop(context);
        }
        text = '等待对方中  ${sec}s';
      });
    });
  }
}
