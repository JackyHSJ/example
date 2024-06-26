



import 'dart:io';

import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class TouchFeedbackUtil {

  static lightImpact() {
    if (Platform.isIOS) {
      HapticFeedback.lightImpact();
    } else {
      Vibration.vibrate(duration: 30, amplitude: 50);
    }
  }

  static mediumImpact() {
    if (Platform.isIOS) {
      HapticFeedback.mediumImpact();
    } else {
      Vibration.vibrate(duration: 50, amplitude: 100);
    }
  }

  static heavyImpact() {
    if (Platform.isIOS) {
      HapticFeedback.heavyImpact();
    } else {
      Vibration.vibrate(duration: 70, amplitude: 150);
    }
  }
}