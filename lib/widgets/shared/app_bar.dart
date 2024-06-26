import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {


  const MainAppBar({
    super.key,
    required this.title,
    this.theme ,
    this.actions,
    this.backgroundColor = Colors.transparent,
    this.foregroundColor,
    this.statusBarColors,
    this.leading,
    this.defaultIconColor,
    this.titleWidget,
    this.onTapLeading});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  ConsumerState<MainAppBar> createState() => _MainAppBarState();

  final AppTheme? theme;
  final String title;
  final List<Widget>? actions;
  final Color backgroundColor;
  final Color? foregroundColor;
  final Color? statusBarColors;
  final Widget? leading;
  final Color? defaultIconColor;
  final Widget? titleWidget;
  final Function()? onTapLeading;

}
class _MainAppBarState extends ConsumerState<MainAppBar> {

  AppTheme get _theme => widget.theme ?? AppTheme(themeType: AppThemeType.original);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight(),
      width: MediaQuery.of(context).size.width,
      color: widget.statusBarColors??widget.backgroundColor,
      child: SafeArea(
        top: true,
        bottom: false,
        child: AppBar(
          backgroundColor: widget.backgroundColor, // 設定 AppBar 為透明
          foregroundColor: widget.foregroundColor,
          elevation: 0, // 移除 AppBar 的陰影
          leadingWidth: 40.w,
          leading: widget.leading ??
              InkWell(
                child: Container(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Image(image: AssetImage('assets/icons/icon_navigationbar_back.png'),),
                ),
                onTap:(){
                  Navigator.pop(context);
                  if(widget.onTapLeading !=null){
                    widget.onTapLeading!().call;
                  }
                } ,
              ),
          centerTitle: true,
          scrolledUnderElevation: 0,
          title: widget.titleWidget ?? Text(widget.title, style: _theme.getAppTextTheme.appbarTextStyle),
          actions: widget.actions,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(UIDefine.getAppBarHeight());
}
