import 'dart:async';

enum TimerType {
  days, hours, minutes, seconds, milliseconds, microseconds
}

class TimerUtil {
  static final TimerUtil _singleton = TimerUtil._internal();
  TimerUtil._internal();

  factory TimerUtil() {
    return _singleton;
  }

  static Timer periodic({
    required TimerType timerType,
    required int timerNum,
    required Function(Timer) timerCallback
  }) {
    Duration duration;

    switch (timerType) {
      case TimerType.days:
        duration = Duration(days: timerNum);
        break;
      case TimerType.hours:
        duration = Duration(hours: timerNum);
        break;
      case TimerType.minutes:
        duration = Duration(minutes: timerNum);
        break;
      case TimerType.seconds:
        duration = Duration(seconds: timerNum);
        break;
      case TimerType.milliseconds:
        duration = Duration(milliseconds: timerNum);
        break;
      case TimerType.microseconds:
        duration = Duration(microseconds: timerNum);
        break;
    }

    return Timer.periodic(duration, (timer) => timerCallback(timer));
  }
}
