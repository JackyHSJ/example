import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frechat/screens/home/home.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';


class PhoneLoginVerify extends StatefulWidget {
  const PhoneLoginVerify({super.key});

  @override
  State<PhoneLoginVerify> createState() => _PhoneLoginVerifyState();
}

class _PhoneLoginVerifyState extends State<PhoneLoginVerify> {
  final TextEditingController _digit1Controller = TextEditingController();
  final FocusNode _digit1InputFocus = FocusNode();

  final TextEditingController _digit2Controller = TextEditingController();
  final FocusNode _digit2InputFocus = FocusNode();

  final TextEditingController _digit3Controller = TextEditingController();
  final FocusNode _digit3InputFocus = FocusNode();

  final TextEditingController _digit4Controller = TextEditingController();
  final FocusNode _digit4InputFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          children: [
            Text(
              '填寫驗證碼',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              '驗證已發送',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 32,
            ),
            _verifyCodeInputFields(),
            const SizedBox(
              height: 16,
            ),
            CommonButton(
              btnType: CommonButtonType.text,
              cornerType: CommonButtonCornerType.circle,
              isEnabledTapLimitTimer: false,
              text: '送出驗證碼',
              onTap: () {
                BaseViewModel.pushAndRemoveUntil(context, const Home(showAdvertise: true,));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _verifyCodeInputFields() {
    return SizedBox(
      height: 64,
      child: Row(
        children: [
          //D1
          Flexible(
            child: TextField(
              controller: _digit1Controller,
              focusNode: _digit1InputFocus,
              textInputAction: TextInputAction.done,
              enableSuggestions: false,
              enableIMEPersonalizedLearning: false,
              keyboardType: TextInputType.number,
              autocorrect: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                labelStyle: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey),
                hintStyle: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                hintText: '',
                counterText: '',
              ),
              textAlign: TextAlign.center,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              maxLength: 1,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.apply(color: Colors.grey.shade700),
              onChanged: (v) {},
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          //D2
          Flexible(
            child: TextField(
              controller: _digit2Controller,
              focusNode: _digit2InputFocus,
              textInputAction: TextInputAction.done,
              enableSuggestions: false,
              enableIMEPersonalizedLearning: false,
              keyboardType: TextInputType.number,
              autocorrect: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                labelStyle: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey),
                hintStyle: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                hintText: '',
                counterText: '',
              ),
              textAlign: TextAlign.center,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              maxLength: 1,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.apply(color: Colors.grey.shade700),
              onChanged: (v) {},
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          //D3
          Flexible(
            child: TextField(
              controller: _digit3Controller,
              focusNode: _digit3InputFocus,
              textInputAction: TextInputAction.done,
              enableSuggestions: false,
              enableIMEPersonalizedLearning: false,
              keyboardType: TextInputType.number,
              autocorrect: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                labelStyle: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey),
                hintStyle: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                hintText: '',
                counterText: '',
              ),
              textAlign: TextAlign.center,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              maxLength: 1,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.apply(color: Colors.grey.shade700),
              onChanged: (v) {},
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          //D4
          Flexible(
            child: TextField(
              controller: _digit4Controller,
              focusNode: _digit4InputFocus,
              textInputAction: TextInputAction.done,
              enableSuggestions: false,
              enableIMEPersonalizedLearning: false,
              keyboardType: TextInputType.number,
              autocorrect: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                labelStyle: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey),
                hintStyle: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                hintText: '',
                counterText: '',
              ),
              textAlign: TextAlign.center,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              maxLength: 1,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.apply(color: Colors.grey.shade700),
              onChanged: (v) {},
            ),
          ),
        ],
      ),
    );
  }
}
