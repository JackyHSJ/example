import 'package:flutter/scheduler.dart';

class GlobalTickerProvider implements TickerProvider {
  Ticker? _ticker;

  @override
  Ticker createTicker(TickerCallback onTick) {
    _ticker = Ticker(onTick);
    return _ticker!;
  }

  /// Start the Ticker (Usually you don't need this as creating an animation controller should implicitly start it.)
  void start() {
    _ticker!.start();
  }

  /// Dispose the Ticker
  void dispose() {
    _ticker!.dispose();
  }
}