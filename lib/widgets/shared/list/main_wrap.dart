import 'package:flutter/material.dart';

class MainWrap {
  Widget wrap({required List<Widget> children}) {
    return Wrap(
      spacing: 5,
      runSpacing: 8,
      children: children,
    );
  }
}
