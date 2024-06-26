import 'package:flutter/material.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class CheckboxItem extends StatelessWidget {
  const CheckboxItem(
      {this.child,
      this.text = '',
      this.expandChild = false,
      this.leading,
      this.trailing,
      this.tristate = false,
      required this.value,
      this.isCheckBoxTrailing = false,
      this.mainAxisSize = MainAxisSize.min,
      this.onChanged,
      Key? key})
      : super(key: key);

  final Widget? child;
  final String text;
  final bool expandChild;
  final Widget? leading;
  final Widget? trailing;
  final bool tristate;
  final bool? value;
  final bool isCheckBoxTrailing;
  final MainAxisSize mainAxisSize;
  final Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    Widget childWidget = Container();
    //Use child or text?
    if (child != null) {
      //child
      if (expandChild) {
        childWidget = Expanded(child: child!);
      } else {
        childWidget = Flexible(child: child!);
      }
    } else {
      //text
      if (expandChild) {
        childWidget = Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      } else {
        childWidget = Flexible(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (value != null) {
            onChanged?.call(!value!);
          } else {
            onChanged?.call(true);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (leading != null) ? leading! : (Container()),
            Visibility(
              visible: !isCheckBoxTrailing,
              child: IgnorePointer(
                child: Checkbox(
                  checkColor: AppColors.mainGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  side: MaterialStateBorderSide.resolveWith(
                    (states) =>
                        const BorderSide(width: 1.5, color: AppColors.mainGrey),
                  ),
                  fillColor: const MaterialStatePropertyAll(Colors.white),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  tristate: tristate,
                  value: value,
                  onChanged: (b) {},
                ),
              ),
            ),
            Visibility(
                visible: isCheckBoxTrailing,
                child: const SizedBox(
                  width: 12,
                )),
            childWidget,
            Visibility(
                visible: !isCheckBoxTrailing,
                child: const SizedBox(
                  width: 12,
                )),
            Visibility(
              visible: isCheckBoxTrailing,
              child: IgnorePointer(
                child: Checkbox(
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  tristate: tristate,
                  value: value,
                  onChanged: (b) {},
                ),
              ),
            ),
            (trailing != null) ? trailing! : (Container()),
          ],
        ),
      ),
    );
  }
}
