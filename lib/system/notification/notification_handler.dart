

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frechat/models/zpns/call_payload_model.dart';
import 'package:frechat/models/zpns/offline_call_model.dart';
import 'package:frechat/screens/home/home.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/notification/const/notification_setting.dart';
import 'package:frechat/system/notification/model/received_notification.dart';
import 'package:frechat/system/zego_call/zego_callback.dart';
import 'package:frechat/widgets/shared/dialog/base_dialog.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:zego_zpns/zego_zpns.dart';

class NotificationHandler {
  /// Streams are created so that app can respond to notification-related events
  /// since the plugin is initialised in the `main` function
  static StreamController<ReceivedNotification>? didReceiveLocalNotificationStream;
  static StreamController<String?>? selectNotificationStream;

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static MethodChannel platform = const MethodChannel('dexterx.dev/flutter_local_notifications_example');
  static String? selectedNotificationPayload;
  static dynamic initialRoute;

  static int currentId = 0;

  static void initStreamController() {
    didReceiveLocalNotificationStream ??= StreamController<ReceivedNotification>.broadcast();
    selectNotificationStream ??= StreamController<String?>.broadcast();
  }

  static void addListener() {
    if(didReceiveLocalNotificationStream == null || selectNotificationStream == null) {
      initStreamController();
    }
    didReceiveLocalNotificationStream?.stream.listen((received) async {
      /// iOS用, 收到推播用
    });

    selectNotificationStream?.stream.listen((payload) async {
      switch(payload) {
        case NotificationSetting.offlineCallAnswer:
          ZegoCallBack.type = OfflineCallType.accept;
          break;
        case NotificationSetting.offlineCallHangUp:
          ZegoCallBack.type = OfflineCallType.handout;
          break;
        default:
          break;
      }
    });
  }

  static void disposeListener() {
    didReceiveLocalNotificationStream?.close();
    selectNotificationStream?.close();
  }

  static initNotificationAppLaunch() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb && Platform.isLinux
        ? null
        : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    initialRoute = const Home(showAdvertise: true);
    final bool check = notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
    if (check) {
      selectedNotificationPayload = notificationAppLaunchDetails!.notificationResponse?.payload;
      /// 替換為點擊本地推播的指定指向頁面
      initialRoute = const Home(showAdvertise: true);
    }
  }

  static List<DarwinNotificationCategory> _getDarwinNotificationCategoryList() {
    final List<DarwinNotificationCategory> darwinNotificationCategories = <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        NotificationSetting.darwinNotificationCategoryText,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text('text_1', 'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        NotificationSetting.darwinNotificationCategoryPlain,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain('id_2', 'Action 2 (destructive)',
            options: <DarwinNotificationActionOption>{DarwinNotificationActionOption.destructive,},
          ),
          DarwinNotificationAction.plain(NotificationSetting.navigationActionId, 'Action 3 (foreground)',
            options: <DarwinNotificationActionOption>{DarwinNotificationActionOption.foreground,},
          ),
          DarwinNotificationAction.plain('id_4', 'Action 4 (auth required)',
            options: <DarwinNotificationActionOption>{DarwinNotificationActionOption.authenticationRequired,},
          ),
        ],
        options: <DarwinNotificationCategoryOption>{DarwinNotificationCategoryOption.hiddenPreviewShowTitle,},
      )
    ];

    return darwinNotificationCategories;
  }

  static InitializationSettings getInitializationSettings() {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: _getSettingsDarwin(),
      macOS: _getSettingsDarwin(),
    );

    return initializationSettings;
  }

  static DarwinInitializationSettings _getSettingsDarwin() {
    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationStream?.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      },
      notificationCategories: _getDarwinNotificationCategoryList(),
    );
    return initializationSettingsDarwin;
  }

  static Future<void> initialize() async {
    await flutterLocalNotificationsPlugin.initialize(
      getInitializationSettings(),
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream?.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            selectNotificationStream?.add(notificationResponse.actionId);
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse notificationResponse) {

    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      print('notification action tapped with input: ${notificationResponse.input}');
    }
  }

  static Future<void> configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  static Future<void> showIncomingCallNotification({
    required ZPNsMessage zpnsMessage
  }) async {
    final OfflineCallExtrasModel extras = OfflineCallExtrasModel.fromJson(zpnsMessage.extras);
    final Map<String, dynamic> payloadMap = json.decode(extras.payload ?? '');
    final CallPayloadModel payloadModel = CallPayloadModel.fromJson(payloadMap);
    final int timeout = payloadModel.timeout.toInt(); // 秒
    final String callerAvatar = payloadModel.callerAvatar;
    final String callName = payloadModel.callerName;
    final String callId = extras.zego?.callId ?? '';

    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'incoming_call_channel_id', // 通道ID
      '来电通话', // 通道名称
      channelDescription: '来电通话的离线推送通道', // 通道描述
      importance: Importance.max,
      priority: Priority.max,
      audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
      fullScreenIntent: false, // 在Android上显示为全屏意图
      additionalFlags: Int32List.fromList([4]), // 设置FLAG_INSISTENT使通知持续振动
      timeoutAfter: timeout * 1000, // 设置通知在60秒后自动取消
      enableVibration: true,
      autoCancel: true,
      showWhen: true,
      usesChronometer: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]), // 设置振动模式
      actions: <AndroidNotificationAction>[
        const AndroidNotificationAction(NotificationSetting.offlineCallAnswer, '接听', icon: DrawableResourceAndroidBitmap('ic_launcher'), showsUserInterface: true, contextual: true),
        const AndroidNotificationAction(NotificationSetting.offlineCallHangUp, '拒接', icon: DrawableResourceAndroidBitmap('ic_launcher'), showsUserInterface: true, contextual: true),
      ],
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    currentId = _getConvertId(int.tryParse(callId) ?? 0);
    await flutterLocalNotificationsPlugin.show(
      currentId, // 通知ID
      '来电通话', // 通知标题
      callName, // 通知内容
      platformChannelSpecifics,
      payload: 'custom_sound',
    );
  }

  // 将大整数转换为32位范围内的整数
  static int _getConvertId(int originalValue) {
    int modValue = originalValue % (1 << 32);
    if (modValue >= (1 << 31)) {
      return modValue - (1 << 32);
    } else {
      return modValue;
    }
  }
}