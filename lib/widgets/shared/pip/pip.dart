import 'package:flutter/material.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/widgets/constant_value.dart';



class PipUtil {
  static double top = 10;
  static double left = 10;
  
  /// pip 狀態
  static PipStatus pipStatus = PipStatus.init;


  static OverlayEntry? overlayEntry;

  static final double windowsHeight = WidgetValue.smallVideoHeight;
  static final double windowsWidth = WidgetValue.smallVideoWidth;

  static void enterPiPMode(BuildContext context, {
    required ViewChange setState,
    required Widget pipWidget,
    required Widget pushPage,
  }) {
    pipStatus = PipStatus.piping;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: top,
        left: left,
        child: GestureDetector(
          onTap: () {
            exitPiPMode();
            BaseViewModel.pushPage(context, pushPage);
          },
          child: Draggable(
            feedback: ClipRRect(
              borderRadius: BorderRadius.circular(WidgetValue.btnRadius / 2),
              child: pipWidget,
            ),
            childWhenDragging: Container(),
            onDragEnd: (dragDetails) {
              final screenSize = MediaQuery.of(context).size;

              top = dragDetails.offset.dy;
              left = dragDetails.offset.dx;
              if (top < 0) {
                top = 0;
              } else if (top > screenSize.height - windowsHeight) {
                top = screenSize.height - windowsHeight;
              }
              if (left < 0) {
                left = 0;
              } else if (left > screenSize.width - windowsWidth) {
                left = screenSize.width - windowsWidth;
              }
              overlayEntry?.markNeedsBuild();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(WidgetValue.btnRadius / 2), // 這裡設定圓角的大小
              child: pipWidget,
            ),
          ),
        ),
      ),
    );

    BaseViewModel.popPage(context);
    Overlay.of(context).insert(overlayEntry!);
    setState((){});
  }

  static void exitPiPMode() {
    pipStatus = PipStatus.closeButUsed;
    if(overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
  }

  // Widget getPiPActionButton() {
  //   return IconButton(
  //     icon: const Icon(Icons.picture_in_picture),
  //     onPressed: () => enterPiPMode(),
  //   );
  // }
}
