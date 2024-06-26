import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:lottie/lottie.dart';

class HeartbeatButton extends StatefulWidget {

  final double width;
  final double height;
  final Function() onTap;
  final Function()? onCheck;

  const HeartbeatButton({
    super.key,
    required this.onTap,
    required this.width,
    required this.height,
    this.onCheck
  });

  @override
  State<HeartbeatButton> createState() => _HeartbeatButtonState();
}

class _HeartbeatButtonState extends State<HeartbeatButton> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void onTapHandler() async {
    bool? checkResult = widget.onCheck?.call();
    if (checkResult != true) return;
    startAnimationOnce();
  }

  // 執行一次的動畫
  void startAnimationOnce() {
    _controller.value = 0;
    _controller.duration = const Duration(seconds: 1);
    _controller.forward();
    widget.onTap.call();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildHearBtn();
  }

  Widget _buildHearBtn() {
    return GestureDetector(
      onTap: () => onTapHandler(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildBoxWidget(),
          _buildLottieAnimationWidget(),
          // _buildHeartIconWidget(),
          _buildTextWidget(),
        ],
      ),
    );
  }

  Widget _buildBoxWidget() {
    return Container(
      width: 67,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: const Color(0xffE0E0E0),
        ),
      ),
    );
  }

  Widget _buildLottieAnimationWidget() {
    return Positioned(
      top: -15,
      left: -15,
      child: SizedBox(
        width: 64,
        height: 64,
        child: Lottie.asset(
          'assets/strike_up_list/frechat/heart.json',
          fit: BoxFit.cover,
          controller: _controller,
          onLoaded: (composition) {
            _controller..value = 1.0..stop();
          },
        ),
      ),
    );
  }

  // Widget _buildHeartIconWidget() {
  //   return Visibility(
  //     visible: !clicked,
  //     child: Positioned(
  //       top: 10,
  //       left: 10,
  //       child: Image.asset('assets/strike_up_list/frechat/heart.png', width: 16, height: 14, fit: BoxFit.contain),
  //     ),
  //   );
  // }

  Widget _buildTextWidget() {
    return const Positioned(
      top: 9,
      right: 10,
      child: Text(
        '心动',
        style: TextStyle(color: Color(0xffEC6193), fontSize: 14, fontWeight: FontWeight.w500, height: 1),
      ),
    );
  }
}
