import 'package:flutter/material.dart';

@immutable
/// TODO:『AppColorsDog』整理成一份
class
AppColorsDogMain {
  const AppColorsDogMain._();

  static const Color mainBg = Color(0xFFFCFCFC);
  static const Color mainPrimary = Color(0xFFFAD00C);
  static const Color mainSecondary = Color(0xFFFCEFD0);
  static const Color mainDisable = Color(0xFFE0E0E0);
  static const Color mainTextBlack = Color(0xFF422C29);
  static const Color mainTextDarkGray = Color(0xFF7F7F7F);
  static const Color mainTextTeal = Color(0xFF83C2C3);
  static const Color mainTextCoralRed = Color(0xFFED7272);
  static const Color mainSystemMeadowGreen = Color(0xFF94B662);
  static const Color mainSystemOrangeRed = Color(0xFFDE5500);


  static const LinearGradient primaryButtonBg = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [mainPrimary,mainPrimary],
  );

  static const LinearGradient secondaryButtonBg = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [mainSecondary,mainSecondary],
  );

  static const LinearGradient disabledButtonBgColor = LinearGradient(
    colors: [mainDisable, mainDisable],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

