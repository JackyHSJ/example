import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/screens/home/home.dart';
import 'package:frechat/screens/launch/launch.dart';
import 'package:frechat/screens/welcome.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/network_status/network_status_manager.dart';
import 'package:frechat/system/notification/zpns/zpns_service.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/widget_binding/track_view.dart';

/// App 的起點，通常只管理 router / theme 以及有必要在最初期做初始化的東西。
class FreChat extends ConsumerStatefulWidget {
  const FreChat({super.key});

  @override
  ConsumerState<FreChat> createState() => _FreChatState();
}

class _FreChatState extends ConsumerState<FreChat> {
  @override
  void initState() {
    super.initState();

    /// widgets 系統與底層的 Flutter 引擎已經完成連接
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    /// 網路狀態檢查
    final NetworkManager networkManager = ref.read(networkManagerProvider);
    networkManager.init();
    networkManager.initNetWorkStatusListener();

    /// 同步通話狀態
    ref.read(callSyncManagerProvider).init();

    /// 開啟底部導航的 Listener
    // ref.read(trackNavigatorProvider).initAnalyticsNaviBarListenerForTab();

    /// offline call use.
    ZPNsService.setBackGroundMode();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final TrackNavigatorObserver navigatorObservers = ref.read(trackNavigatorProvider);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            // theme: AppTheme.themeData(context, type: theme),
            home: const Launch(),
            navigatorKey: GlobalData.globalKey,
            routes: _router,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,//多加这行代码
            ],
            supportedLocales: [
              const Locale('en', 'US'), // 美国英语
              const Locale('zh', 'CN'), // 中文简体
              //其它Locales
            ],
            title: '${AppConfig.appName}',
            // navigatorObservers: [navigatorObservers],
          ),
        );
      },
    );
  }

  //這是所有頁面的路由管理
  // GoRouter configuration
  final _router = {
    // '/': (context) => const Launch(),
    '/Welcome': (context) => const Welcome(),
    '/Home': (context) => const Home(showAdvertise: true),
  };
}
