import 'package:flutter/material.dart';
import 'package:frechat/widgets/shared/buttons/gradient_button.dart';

class RibbonCrystalDialog extends StatelessWidget {
  const RibbonCrystalDialog(
      {required this.title,
      required this.bodyText,
      required this.bodyWidget,
      this.confirmBtnText = '确定',
      super.key});

  final String title;
  final String bodyText;
  final Widget bodyWidget;
  final String confirmBtnText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                //Main Body
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        //Text
                        _bodyText(context),

                        const SizedBox(
                          height: 16,
                        ),

                        //Widget
                        bodyWidget,

                        const SizedBox(
                          height: 16,
                        ),

                        //Button
                        GradientButton(
                          text: confirmBtnText,
                          radius: 48,
                          height: kMinInteractiveDimension,
                          textStyle: const TextStyle(
                              color: Colors.white, fontSize: 12),
                          gradientColorBegin:
                              const Color.fromRGBO(255, 49, 121, 1),
                          gradientColorEnd:
                              const Color.fromRGBO(255, 49, 121, 1),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                ),

                //上方黃色 Title
                Positioned(
                  top: -120,
                  left: 10,
                  right: 10,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.passthrough,
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                          'assets/strike_up_list/ribbon_crystal_title.png'),
                      Transform.translate(
                          offset: const Offset(0, 18),
                          child: _titleText(context)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleText(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _bodyText(BuildContext context) {
    return Text(bodyText,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Colors.grey.shade800));
  }
}
