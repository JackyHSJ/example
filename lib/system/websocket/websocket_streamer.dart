import 'dart:async';
import 'dart:convert';
import 'package:frechat/system/websocket/websocket_handler.dart';

@Deprecated('還尚未使用到')
class WebSocketStreamer {
  StreamController streamController;
  StreamSubscription streamSubscription;

  Function onError; // Socket Error
  Function() onOpen; // Socket Open
  Function(dynamic) onMessage; // Get Message

  WebSocketStreamer({
    required this.streamController,
    required this.streamSubscription,
    required this.onError,
    required this.onOpen,
    required this.onMessage,
  });

  void listener(String topic) {
    streamSubscription = streamController.stream.listen((data) =>
        onMessage(data),
        onError: onError, onDone: onOpen);
  }

  /// Subscribe & unSubscribe
  /// Subscribe with topic
  void subscribe(String topic) {
    Map<String, dynamic> subscription = {};
    subscription['action'] = 'subscribe';
    subscription['topic'] = topic;
    final String jsonStr = json.encode(subscription);
    WebSocketHandler.sendMessage(jsonStr);
    print('Subscribed to: $topic');
  }

  /// Unsubscribe with topic
  void unsubscribe(String topic) {
    Map<String, dynamic> subscription = {};
    subscription['action'] = 'unsubscribe';
    subscription['topic'] = topic;
    final String jsonStr = json.encode(subscription);
    WebSocketHandler.sendMessage(jsonStr);
    print('Unsubscribed from: $topic');
  }

  void dispose() {
    streamSubscription.cancel();
    streamController.close();
  }
}
