import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class TextFromAssetWidget extends ConsumerStatefulWidget {
  final String filePath;
  final String title;

  const TextFromAssetWidget(
      {Key? key, required this.title, required this.filePath})
      : super(key: key);

  @override
  _TextFromAssetWidgetState createState() => _TextFromAssetWidgetState();
}

class _TextFromAssetWidgetState extends ConsumerState<TextFromAssetWidget> {
  String _text = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadText();
  }

  Future<void> _loadText() async {
    String assetText = await rootBundle.loadString(widget.filePath);
    _text = assetText;
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppColorTheme appColorTheme = theme.getAppColorTheme;
    final AppImageTheme appImageTheme = theme.getAppImageTheme;
    final AppTextTheme appTextTheme = theme.getAppTextTheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title,style: appTextTheme.appbarTextStyle),
        centerTitle: true,
        backgroundColor: appColorTheme.appBarBackgroundColor,
        leading: GestureDetector(
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Image(
              image: AssetImage(appImageTheme.iconBack),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        // padding: const EdgeInsets.all(16),
        color: appColorTheme.appBarBackgroundColor,
        child: isLoading
            ? const SizedBox()
            : InAppWebView(
          initialData: InAppWebViewInitialData(data: _text),
            initialSettings: InAppWebViewSettings (
              transparentBackground: true,
            )
        ),
      ),
    );
  }
}
