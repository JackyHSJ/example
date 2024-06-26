import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class ProtocolTxt extends ConsumerStatefulWidget {
  final String title;
  final String txt;
  const ProtocolTxt({super.key, required this.txt, required this.title});

  @override
  ConsumerState<ProtocolTxt> createState() => _ProtocolTxtState();
}

class _ProtocolTxtState extends ConsumerState<ProtocolTxt> {
  List<Text>? _listText; // = [];
  late AppTheme _theme;

  _loadTxt() {
    _listText = [];
    //String data = await rootBundle.loadString('assets/txt/personal_regulatory.txt');
    List<String> listTxt = const LineSplitter().convert(widget.txt);
    _listText = _getTxetList(listTxt);
    setState(() {});
  }

  _getTxetList(List<String> list) {
    List<Text> listText = [];
    for (var txt in list) {
      listText.add(Text(txt));
    }
    return listText;
  }

  @override
  void initState() {
    super.initState();
    _loadTxt();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    return Scaffold(
      appBar: MainAppBar(
        theme: _theme,
        title: widget.title,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(23, 0, 23, 33),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...?_listText,
            ],
          ),
        ),
      ),
    );
  }
}
