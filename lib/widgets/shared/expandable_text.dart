import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle? style;

  const ExpandableText({
    Key? key,
    required this.text,
    this.maxLines = 3,
    this.style,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        final span = TextSpan(text: widget.text);
        final tp = TextPainter(
          text: span,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: size.maxWidth);

        if (tp.didExceedMaxLines || isExpanded) {
          String displayText = widget.text;
          String toggleText = "更多";
          if (!isExpanded) {
            int endIndex = _findTruncationIndex(tp, widget.text, '...更多', size.maxWidth);
            displayText = widget.text.substring(0, endIndex - 4) + '...';
          } else {
            toggleText = "收起";
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: widget.style ?? DefaultTextStyle.of(context).style ,
                  children: <TextSpan>[
                    TextSpan(
                      text: displayText,
                    ),
                    TextSpan(
                      text: toggleText,
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Text(widget.text,style: widget.style ?? DefaultTextStyle.of(context).style,);
        }
      },
    );
  }

  int _findTruncationIndex(TextPainter tp, String text, String appendText, double maxWidth) {
    int endIndex = text.length;
    final appendSpan = TextSpan(text: appendText, style: tp.text!.style);
    final appendTp = TextPainter(
      text: appendSpan,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    appendTp.layout();

    while (endIndex > 0) {
      final testSpan = TextSpan(text: text.substring(0, endIndex), style: tp.text!.style);
      final testTp = TextPainter(
        text: testSpan,
        maxLines: widget.maxLines,
        textDirection: TextDirection.ltr,
      );
      testTp.layout(maxWidth: maxWidth - appendTp.width);

      if (testTp.didExceedMaxLines) {
        endIndex--;
      } else {
        break;
      }
    }
    return endIndex;
  }
}
