import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///MARK: 常用call back
typedef onClickFunction = void Function();
typedef onGetIntFunction = void Function(int value);
typedef onGetDoubleFunction = void Function(double value);
typedef onGetStringFunction = void Function(String value);
typedef onGetStringChangeFunction = void Function(String? value);
typedef onGetBoolFunction = void Function(bool value);

///MARK: response
typedef ResponseErrorFunction = void Function(String errorMessage);

///MARK: setState
typedef ViewChange = void Function(VoidCallback fn);

/// for search bar decide show keyboard
typedef ShowKeyBoard = bool Function();

/// check data
typedef PressVerification = Future<bool> Function();

/// return country code
typedef GetCountryInfo = void Function(
    String country, String countryCode, String countryImage);
