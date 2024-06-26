import 'dart:io';

import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/screens/profile/call_limit/edit_call_charge_sort_dialog.dart';
import 'package:frechat/screens/profile/call_limit/personal_call_limit_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/profile/cell/personal_free_call_limit_cell.dart';
import 'package:frechat/widgets/profile/cell/personal_free_call_no_limit_cell.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/dialog/base_dialog.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/tab_bar/main_tab_bar.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class PersonalCallLimit extends ConsumerStatefulWidget  {
  const PersonalCallLimit({super.key});

  @override
  ConsumerState<PersonalCallLimit> createState() => _PersonalCallLimitState();
}

class _PersonalCallLimitState extends ConsumerState<PersonalCallLimit> with TickerProviderStateMixin {
  late PersonalCallLimitViewModel viewModel;
  late AppTheme _theme;
  late AppColorTheme appColorTheme;
  late AppImageTheme appImageTheme;
  late AppTextTheme appTextTheme;
  late AppLinearGradientTheme appLinearGradientTheme;
  late List<DragAndDropList> _contents;


  @override
  void initState() {
    super.initState();
    viewModel = PersonalCallLimitViewModel(setState: setState, ref: ref, context: context, tickerProvider: this);
    viewModel.init(context);


    // _contents = List.generate(10, (index) {
    //   return DragAndDropList(
    //     children: <DragAndDropItem>[
    //       DragAndDropItem(
    //         child: Text('$index.1'),
    //       ),
    //       DragAndDropItem(
    //         child: Text('$index.2'),
    //       ),
    //       DragAndDropItem(
    //         child: Text('$index.3'),
    //       ),
    //     ],
    //   );
    // });
    // _contents = [DragAndDropList(
    //   children: <DragAndDropItem>[
    //     DragAndDropItem(
    //         child: item('不限对象免费通话额度', true)
    //     ),
    //     DragAndDropItem(
    //         child: item('VIP 限定免费通话额度', true)
    //     ),
    //     DragAndDropItem(
    //         child: item('限定对象免费通话额度', true)
    //     ),
    //     DragAndDropItem(
    //         child: item('使用金币', false)
    //     ),
    //   ],
    // )];

    _contents = [DragAndDropList(
      children: <DragAndDropItem>[
        DragAndDropItem(
            child: item('不限对象免费通话额度', true)
        ),
      ],
    ),DragAndDropList(
      children: <DragAndDropItem>[
        DragAndDropItem(
            child: item('VIP 限定免费通话额度', true)
        ),
      ],
    ),DragAndDropList(
      children: <DragAndDropItem>[
        DragAndDropItem(
            child: item('限定对象免费通话额度', true)
        ),
      ],
    ),DragAndDropList(
      children: <DragAndDropItem>[
        DragAndDropItem(
            child: item('使用金币', false)
        ),
      ],
    )];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appColorTheme = _theme.getAppColorTheme;
    appImageTheme = _theme.getAppImageTheme;
    appTextTheme = _theme.getAppTextTheme;
    appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();

    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: false,
      padding: EdgeInsets.only(top: paddingHeight),
      appBar: MainAppBar(
        theme: _theme,
        title: '我的免费额度',
        backgroundColor: appColorTheme.appBarBackgroundColor,
        leading: Padding(padding: EdgeInsets.only(left:10.w),child: IconButton(
          icon: ImgUtil.buildFromImgPath(appImageTheme.iconBack, size: 24.w),
          onPressed: () => BaseViewModel.popPage(context),
        )),
      ),
      backgroundColor: appColorTheme.appBarBackgroundColor,
      floatingActionButton: editMySort(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      child: Column(
        children: [
          _buildTabBar(),
          SizedBox(height: WidgetValue.verticalPadding),
          Expanded(child: _buildTabBarView())
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppColorTheme appColorTheme = theme.getAppColorTheme;
    return Container(
      margin: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding,horizontal: 16.w),
      height: WidgetValue.tabBarHeight,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: appColorTheme.tabBarBackgroundColor,
        borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2),
      ),
      child: MainTabBar(controller: viewModel.tabController, tabList: viewModel.tabList).tabBar(
        padding: EdgeInsets.zero,
        selectTextStyle: const TextStyle(color: AppColors.mainPink, fontWeight: FontWeight.w500),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
            color: AppColors.whiteBackGround,
            borderRadius: BorderRadius.circular(25.0)
        ),
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: viewModel.tabController,
      children: [
        _buildVip(),
        _buildNoLimitPerson(),
        _buildLimitPerson(),
      ],
    );
  }

  ///VIP限定
  Widget _buildVip() {
    return Consumer(builder: (context, ref, _){
      return isNotVip();
    });
  }

  ///不是VIP
  Widget isNotVip(){
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: 43.h),
            child: Image(
          width: 150.w,
          height: 150.w,
          image: const AssetImage('assets/images/personal_isnot_vip.png'),
        )),
        Padding(padding: EdgeInsets.only(top: 16.h),
            child: Text('您尚未成为VIP',
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(68, 70, 72, 1)
            ))),
        Text('快去升级吧!',
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(68, 70, 72, 1)
            )),
        goToBeVip()
      ],
    );
  }

  ///升级VIP按钮
  Widget goToBeVip(){
    return Container(
      margin: EdgeInsets.only(top: 24.h),
      padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 40.5.w),
      decoration:  BoxDecoration(
        gradient: appLinearGradientTheme.buttonPrimaryColor,
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Text(
        "升级VIP",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }

  ///不限对象
  Widget _buildNoLimitPerson() {
    return Consumer(builder: (context, ref, _){
      return SingleChildScrollView(
        child: Column(
          children: [
            PersonalFreeCallNoLimitCallCell(des: '语音或视讯', freeTime: '3', expirationDate: '2024/03/30'),
            PersonalFreeCallNoLimitCallCell(des: '视讯', freeTime: '10', expirationDate: '2024/03/30'),
            PersonalFreeCallNoLimitCallCell(des: '语音', freeTime: '5', expirationDate: '2024/03/30'),
            PersonalFreeCallNoLimitCallCell(des: '语音', freeTime: '5', expirationDate: '2024/03/30'),
            PersonalFreeCallNoLimitCallCell(des: '语音', freeTime: '5', expirationDate: '2024/03/30'),
            PersonalFreeCallNoLimitCallCell(des: '语音', freeTime: '5', expirationDate: '2024/03/30'),
            PersonalFreeCallNoLimitCallCell(des: '语音', freeTime: '5', expirationDate: '2024/03/30'),
            PersonalFreeCallNoLimitCallCell(des: '语音', freeTime: '5', expirationDate: '2024/03/30'),
            PersonalFreeCallNoLimitCallCell(des: '语音', freeTime: '5', expirationDate: '2024/03/30'),
          ],
        )
      );
    });
  }

  ///特定对象
  Widget _buildLimitPerson() {
    return Consumer(builder: (context, ref, _){
      return SingleChildScrollView(
        child: Column(
          children: [
            PersonalFreeCallLimitCallCell(limitName: '麻辣串串', des: '语音或视讯', freeTime: '3', expirationDate: '2024/03/30'),
            PersonalFreeCallLimitCallCell(limitName: '麻辣串串', des: '语音', freeTime: '10', expirationDate: '2024/03/30'),
            PersonalFreeCallLimitCallCell(limitName: '韩式辣味锅贴', des: '语音', freeTime: '10', expirationDate: '2024/03/30'),
          ],
        )
      );
    });
  }

  ///右下角排序按钮
  Widget editMySort(){
    return InkWell(
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 40.5.w),
          width: 160.w,
          height: 48.h,
          decoration:  BoxDecoration(
            gradient: appLinearGradientTheme.buttonPrimaryColor,
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                width: 24.w,
                height: 24.w,
                image: const AssetImage('assets/images/icon_editsort.png'),
              ),
              SizedBox(width: 2.w),
              Text(
                "编辑我的排序",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500
                ),
              )
            ],
          )
      ),
      onTap: (){
        openEditCallChargeSortDialog();
        // BaseDialog(context).showTransparentDialog(
        //     isDialogCancel: false,
        //     widget: EditCallChargeSortDialog()
        // );
      },
    );
  }

  void openEditCallChargeSortDialog(){

    CommDialog(context).build(
      theme: _theme,
        isDialogCancel : false,
        title: '设置使用排序',
        contentDes: '',
        leftBtnTitle: '取消',
        rightBtnTitle: '確定',
        rightTextStyle: appTextTheme.buttonPrimaryTextStyle,
        leftTextStyle: appTextTheme.buttonSecondaryTextStyle,
        backgroundColor: appColorTheme.dialogBackgroundColor,
        rightLinearGradient: appLinearGradientTheme.buttonPrimaryColor,
        leftLinearGradient: appLinearGradientTheme.buttonSecondaryColor,
        widget: dialogContent(),
        leftAction: () => BaseViewModel.popPage(context),
        rightAction: () => BaseViewModel.popPage(context),
    );
  }

  Widget dialogContent(){
    return Container(
      width: 311,
      height: 192,
      child: DragAndDropLists(
        children: _contents,
        onItemReorder: _onItemReorder,
        onListReorder: _onListReorder,
      ),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _contents.removeAt(oldListIndex);
      _contents.insert(newListIndex, movedList);
    });
  }

  Widget item(String title,bool isFree){
    return Row(
      children: [
        Image(
          width: 44.w,
          height: 16.h,
          image:  AssetImage((isFree)?'assets/images/icon_free_tag.png':'assets/images/icon_coin_tag.png'),
        ),
        Text(title,
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(68, 70, 72, 1)
            )),
        Expanded(child: SizedBox()),
        Image(
          width: 24.w,
          height: 24.w,
          image: const AssetImage(
              'assets/images/icon_sort_item.png'),
        )
      ],
    );
  }

}

