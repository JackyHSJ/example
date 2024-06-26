import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/screens/strike_up_list/how2tv/strike_up_list_how2tv_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/divider.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';


class TableData {
  final int giftValue;
  final int lockScreen;

  TableData(this.giftValue, this.lockScreen);
}


class StrikeUpListHowToTv extends ConsumerStatefulWidget {
  const StrikeUpListHowToTv({super.key});
  @override
  ConsumerState<StrikeUpListHowToTv> createState() => _StrikeUpListHowToTvState();
}

class _StrikeUpListHowToTvState extends ConsumerState<StrikeUpListHowToTv> {
  late StrikeUpListHowToTvViewModel viewModel;
  AppTheme? theme;
  late AppColorTheme appColorTheme;
  late AppTextTheme appTextTheme;
  late AppImageTheme appImageTheme;
  late AppLinearGradientTheme appLinearGradientTheme;
  late AppBoxDecorationTheme appBoxDecorationTheme;

  _ini() async {
    await viewModel.loadMemberInfo(context);
  }

  @override
  void initState() {
    viewModel = StrikeUpListHowToTvViewModel(setState: setState, ref: ref, context: context);
    super.initState();
    _ini();
  }

  @override
  Widget build(BuildContext context) {
    theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appColorTheme = theme!.getAppColorTheme;
    appTextTheme = theme!.getAppTextTheme;
    appImageTheme = theme!.getAppImageTheme;
    appLinearGradientTheme = theme!.getAppLinearGradientTheme;
    appBoxDecorationTheme = theme!.getAppBoxDecorationTheme;

    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: true,
      backgroundColor: appColorTheme.baseBackgroundColor,
      padding: EdgeInsets.only(
        top: paddingHeight, bottom: WidgetValue.bottomPadding,
        left: WidgetValue.horizontalPadding, right: WidgetValue.horizontalPadding
      ),
      appBar: _buildAppbar(),
      child: Column(
        children: [
          _buildBannerImg(appImageTheme.imgHowToTVBanner),
          _buildTitleImg(appImageTheme.imgHowToTVTitle),
          _buildTvDes(),
          _buildTitleImg(appImageTheme.imgHowToTVHeadline),
          _buildHeadLinesDes(),
        ],
      ),
    );
  }

  // Appbar
  Widget _buildAppbar() {
    return AppBar(
      elevation: 0,
      title: Text(
        "如何上电视",
        style: appTextTheme.appbarTextStyle,
      ),
      backgroundColor: appColorTheme.appBarBackgroundColor,
      centerTitle: true,
      leading: GestureDetector(
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Image(
            image: AssetImage(appImageTheme.iconBack),
          ),
        ),
        onTap: () => BaseViewModel.popPage(context),
      ),
    );
  }

  Widget _buildBannerImg(String imgPath) {
    return Container(
      margin: EdgeInsets.only(top: 11.h),
      child: AspectRatio(
        aspectRatio: 343 / 147,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: ImgUtil.buildFromImgPath(imgPath, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildTitleImg(String imgPath) {
    return ImgUtil.buildFromImgPath(imgPath, width: UIDefine.getWidth() / 2, fit: BoxFit.fitWidth);
  }

  Widget _buildTvDes() {
    return Container(
      padding: EdgeInsets.all(WidgetValue.verticalPadding),
      decoration: appBoxDecorationTheme.strikeUpTvBoxDecoration,
      child: Column(
        children: [
          _tvCell(imgPath: appImageTheme.howToTvTitleNumberOne, des: '上电视', value: 500),
          const SizedBox(height: 8),
          _tvCell(imgPath: appImageTheme.howToTvTitleNumberTwo, des: '锁频展示', value: 5000),
          const SizedBox(height: 8),
          MainDivider(color: appColorTheme.dividerColor, height: 1.h),
          const SizedBox(height: 8),
          _tvTable()
        ],
      ),
    );
  }

  Widget _buildHeadLinesDes() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            viewModel.isWantOnTv = true;
            setState(() {});
          },
          child: _headLineCell(
              imgPath: appImageTheme.howToTvTitleWantOnTV, title: '我想上电视', des: '送礼时显示您的昵称上电视', isSelect: viewModel.isWantOnTv == true),
        ),
        SizedBox(
          height: WidgetValue.verticalPadding,
        ),
        InkWell(
          onTap: () {
            viewModel.isWantOnTv = false;
            setState(() {});
          },
          child: _headLineCell(
              imgPath: appImageTheme.howToTvTitleAnonymous, title: '匿名上电视', des: '送礼时显示神秘人上电视', isSelect: viewModel.isWantOnTv == false),
        ),
        const SizedBox(height: 12)
      ],
    );
  }

  Widget _tvCell({required String imgPath, required String des, required int value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ImgUtil.buildFromImgPath(imgPath, size: WidgetValue.primaryIcon),
        SizedBox(width: WidgetValue.separateHeight),
        Text('单次送礼价值', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1, color: appColorTheme.tvSubTextColor)),
        SizedBox(width: 4.w),
        _tableGiftValueCell(value),
        SizedBox(width: 4.w),
        Text('金币即可', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1, color: appColorTheme.tvSubTextColor)),
        SizedBox(width: WidgetValue.separateHeight),
        Text(des, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1, color: appColorTheme.tvMainTextColor))
      ],
    );
  }

  _tvTable(){

    List<TableData> tableList = [
      TableData(5000, 10),
      TableData(10000, 20),
      TableData(50000, 30),
      TableData(100000, 60),
    ];

    List<TableRow> _tableRows = List.generate(tableList.length, (index) {

      final item = tableList[index];
      final giftValue = item.giftValue;
      final lockScreen = item.lockScreen;
      return TableRow(
        children: [
          _tableGiftValueCell(giftValue),
          _tableLockScreenCell(lockScreen)
        ]
      );
    });

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 1.0, color: const Color(0xFFEAEAEA)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9.0),
        child: Table(
          border: const TableBorder(
            horizontalInside: BorderSide(width: 1.0, color: Color(0xFFEAEAEA)),
            verticalInside: BorderSide(width: 1.0, color: Color(0xFFEAEAEA)),
          ),
          children: [
            _tableTitle(),
            ..._tableRows,
          ],
        ),
      ),
    );
  }

  _tableTitle(){

    return TableRow(
      children: [
        Container(
            height: 36,
            padding: const EdgeInsets.only(left: 8, right: 8),
            color: appColorTheme.tvTitleBgColor,
            child: Center(
              child: Text('送礼价值', style: TextStyle(color: appColorTheme.tvTitleTextColor, fontSize: 12.0, fontWeight: FontWeight.w700, height: 1.25)
              ),
            )
        ),
        Container(
            height: 36,
            padding: const EdgeInsets.only(left: 8, right: 8),
            color: appColorTheme.tvTitleBgColor,
            child: Center(
              child: Text('锁屏展示时间',style: TextStyle(color: appColorTheme.tvTitleTextColor, fontSize: 12.0, fontWeight: FontWeight.w700, height: 1.25)
              ),
            )
        ),
      ],
    );
  }

  Widget _tableGiftValueCell(giftValue){
    return Container(
      height: 36.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('≥', style: TextStyle(color: AppColors.textFormBlack, fontSize: 14.0, fontWeight: FontWeight.w400, height: 1)),
          Image.asset('assets/strike_up_tv/strike_up_tv_coin_icon.png', width: 16, height: 16),
          const SizedBox(width: 1),
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [AppColors.mainOrange,AppColors.mainYellow],
                stops: [0.111, 0.9222],
              ).createShader(bounds);
            },
            child: Text('$giftValue ', style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 14.0, fontWeight: FontWeight.w600, height: 1)),
          ),
        ],
      )
    );
  }

  Widget _tableLockScreenCell(lockScreen){
    return Container(
      height: 36.h,
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/strike_up_tv/strike_up_tv_clock_icon.png', width: 16, height: 16),
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [Color(0xFF647DF6),Color(0xFF59BBE0)],
                stops: [0.111, 0.9222],
              ).createShader(bounds);
            },
            child: Text('$lockScreen ', style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 14.0, fontWeight: FontWeight.w600, height: 1)),
          ),
          const SizedBox(width: 4),
          const Text('秒', style: TextStyle(color: AppColors.textFormBlack, fontSize: 14.0, fontWeight: FontWeight.w400, height: 1)),
        ],
      )
    );
  }

  Widget _headLineCell({required String imgPath, required String title, required String des, required bool isSelect}) {
    return Container(
      padding: EdgeInsets.all(WidgetValue.verticalPadding),
      decoration: isSelect ? appBoxDecorationTheme.tvSelectedBoxDecoration : appBoxDecorationTheme.tvUnSelectBoxDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImgUtil.buildFromImgPath(imgPath, size: 24.w),
          SizedBox(
            width: WidgetValue.separateHeight,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: appColorTheme.tvMainTextColor)),
                Text(des, style: TextStyle(fontWeight: FontWeight.w400, color: appColorTheme.tvSubTextColor),),
              ],
            ),
          ),
          Visibility(visible: isSelect, child: _buildBtn())
        ],
      ),
    );
  }

  Widget _buildBtn() {
    return Container(
      width: 52,
      height: 32,
      decoration: appBoxDecorationTheme.tvSelectedTextBoxDecoration,
      child: Center(
        child: Text(
          '已选取',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: appColorTheme.tvSelectedTextColor),
        ),
      ),
    );
  }
}
