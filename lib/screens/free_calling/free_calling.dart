// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/free_calling/free_calling_banner.dart';
import 'package:frechat/screens/free_calling/free_calling_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/dialog/free_calling_dialog.dart';
import 'package:frechat/widgets/shared/icon_tag.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class FreeCalling extends ConsumerStatefulWidget {
  const FreeCalling({super.key});

  @override
  ConsumerState<FreeCalling> createState() => _FreeCallingState();
}

class _FreeCallingState extends ConsumerState<FreeCalling> {
  late FreeCallingViewModel viewModel;
  final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = FreeCallingViewModel(ref: ref, setState: setState, context: context);
    viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      isFullScreen: true,
      padding: EdgeInsets.only(top: paddingHeight, bottom: UIDefine.getNavigationBarHeight()),
      appBar: _buildMainAppBar('我的免费额度', [], context),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildBanner(),
        _buildMainContent(),
      ],
    ));
  }

  Widget _buildMainAppBar(String title, List<Widget>? action, BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // 設定 AppBar 為透明
      elevation: 0, // 移除 AppBar 的陰影
      leading: GestureDetector(
        child: const Image(
          width: 24,
          height: 24,
          image: AssetImage('assets/images/back.png'),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
      actions: action,
    );
  }

  Widget _buildBanner(){
    return InkWell(
      onTap: (){
        showDailyBanner();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 12, bottom: 24),
        child: ImgUtil.buildFromImgPath('assets/free_calling/banner_kv.png', width: 150.w, size: 150.w),
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        children: [
          _buildItem(viewModel.callList[0]),
          const SizedBox(height: 24),
          _buildItem(viewModel.callList[1]),
          const SizedBox(height: 24),
          _buildItem(viewModel.callList[2]),
        ],
      )
    );
  }

  Widget _buildItem(Map<String, String> content) {

    final String title = content['title'] ?? '';
    final String subTitle = content['subTitle'] ?? '';
    final String des = content['des'] ?? '';


    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconTag.callingFree(),
                  const SizedBox(width: 4),
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.43,
                        color: Color(0xff444648)),
                  ),
                ],
              ),
              Text(
                subTitle,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    height: 1.42,
                    color: Color(0xff444648)),
              ),
              Text(
                des,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 1.33,
                    color: Color(0xff7F7F7F)),
              )
            ],
          ),
        ),
        const SizedBox(width: 24),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.purpleAccent,
              borderRadius: BorderRadius.circular(99.0),
              gradient: AppColors.pinkLightGradientColors
            ),
            child: const Center(
              child: Text(
                '可使用',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    height: 1.42,
                    color: Color(0xffffffff)),
              ),
            )),
      ],
    );
  }

  showDailyBanner(){
    AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    CommDialog(context).build(
      theme: theme,
        title: '选择优先通话类别额度',
        contentDes: '选择优先通话类别额度',
        leftBtnTitle: '取消',
        rightBtnTitle: '立即速配',
        widget: FreeCallingDialog(),
        leftAction: () => BaseViewModel.popPage(context),
        rightAction: () => null
    );
  }
}
