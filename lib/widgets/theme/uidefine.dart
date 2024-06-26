import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UIDefine {
  static bool _isFirst = false; // 第一次初始化

  static double _statusBarHeight = 0.0; // 狀態列高度
  static double _navigationBarHeight = 0.0; // 導航列高度
  static double _screenWidth = 0.0; // 螢幕寬度
  static double _screenHeight = 0.0; // 螢幕高度
  static double _screenWidthUnit = 0.0; // 螢幕寬度單位
  static double _screenHeightUnit = 0.0; // 螢幕高度單位
  static double _fontUnit = 0.0; // 字型單位
  static ThemeData? _getThemeData;
  static ModalRoute? _getModalRoute;

  /// 初始化
  static void initial(MediaQueryData mediaQueryData, ThemeData themeData, ModalRoute<Object?>? modalRoute) {
    _getThemeData = themeData;
    _getModalRoute = modalRoute;

    if (_isFirst) {
      return;
    }
    _isFirst = true;
    _statusBarHeight = mediaQueryData.padding.top;
    _navigationBarHeight = mediaQueryData.padding.bottom;
    _screenWidth = mediaQueryData.size.width;
    _screenHeight = mediaQueryData.size.height;

    _screenWidthUnit = _screenWidth / 100;
    _screenHeightUnit =
        (_screenHeight - _statusBarHeight - _navigationBarHeight) / 100;

    _fontUnit = _screenWidthUnit < _screenHeightUnit
        ? _screenWidthUnit
        : _screenHeightUnit;

    if (kDebugMode) {
      // Release不顯示
      print("狀態列高度:${_statusBarHeight.toString()}");
      print("導航列高度:${_navigationBarHeight.toString()}");
      print("螢幕寬度:${_screenWidth.toString()}");
      print("螢幕高度:${_screenHeight.toString()}");
      print("螢幕寬度單位:${_screenWidthUnit.toString()}");
      print("螢幕高度單位:${_screenHeightUnit.toString()}");
      print("字型單位:${_fontUnit.toString()}");
    }
  }

  /// 取得狀態列高度
  static double getStatusBarHeight() {
    return _statusBarHeight;
  }

  /// 取得AppBar高度
  static double getAppBarHeight() {
    return kToolbarHeight;
  }

  /// 取得導航列高度
  static double getNavigationBarHeight() {
    return _navigationBarHeight;
  }

  /// get screen width
  static double getWidth() {
    return _screenWidth;
  }

  /// get screen height
  static double getHeight() {
    return _screenHeight;
  }

  /// get theme color
  static ThemeData getThemeData() {
    return _getThemeData!;
  }

  /// get theme color
  static ModalRoute getModalRoute() {
    return _getModalRoute!;
  }
}