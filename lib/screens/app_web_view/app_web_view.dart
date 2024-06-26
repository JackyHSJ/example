import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class AppWebView extends ConsumerStatefulWidget {

  final String title;
  final String webUri;

  const AppWebView({
    super.key,
    required this.title,
    required this.webUri
  });

  @override
  ConsumerState<AppWebView> createState() =>  _AppWebViewState();
}

class _AppWebViewState extends ConsumerState<AppWebView> {

  String get title => widget.title;
  String get webUri => widget.webUri;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
        title: Text(title, style: appTextTheme.appbarTextStyle),
        centerTitle: true,
        backgroundColor: appColorTheme.appBarBackgroundColor,
        leading: IconButton(
          icon: ImgUtil.buildFromImgPath(appImageTheme.iconBack, size: 24.w),
          onPressed: () => BaseViewModel.popPage(context),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        color: appColorTheme.appBarBackgroundColor,
        child: Stack(
          children: [
            _buildWebView(),
            Visibility(visible: isLoading, child: _buildLoadingIndicator())
          ],
        )
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildWebView() {
    return InAppWebView(
      initialUrlRequest: URLRequest(
          url: WebUri.uri(Uri.parse(webUri))
      ),
      initialSettings: InAppWebViewSettings (
          transparentBackground: true,
          overScrollMode: OverScrollMode.NEVER
      ),
      onProgressChanged: (InAppWebViewController controller, int int) {
        print("percentage: $int");
      }
      ,
      onLoadStop: (InAppWebViewController controller, Uri? url) {
        isLoading = false;
        setState(() {});
      },
    );
  }

}