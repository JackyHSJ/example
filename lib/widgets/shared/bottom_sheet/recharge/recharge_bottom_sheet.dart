import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_number_option_res.dart';
import 'package:frechat/screens/home/home_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/widgets/banner_view/banner_view.dart';
import 'package:frechat/widgets/shared/bottom_sheet/base_bottom_sheet.dart';

import 'package:frechat/widgets/shared/buttons/gradient_button.dart';
import 'package:frechat/widgets/shared/bottom_sheet/recharge/recharge_bottom_sheet_view_model.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

// 充值彈窗(由下方拉起)
class RechargeBottomSheet extends ConsumerStatefulWidget {

  const RechargeBottomSheet({super.key,required this.theme});
  final AppTheme theme;

  @override
  ConsumerState<RechargeBottomSheet> createState() => _RechargeBottomSheetState();

  static void show({
    required BuildContext context,
    required AppTheme theme,
  }) {
    BaseBottomSheet.showBottomSheet(
      context,
      theme:theme ,
      isScrollControlled: true,
      widget: RechargeBottomSheet(theme: theme),
    );
  }
}

class _RechargeBottomSheetState extends ConsumerState<RechargeBottomSheet> {
  late RechargeBottomSheetViewModel viewModel;
  AppTheme get _theme => widget.theme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  @override
  void initState() {
    super.initState();
    viewModel = RechargeBottomSheetViewModel(ref: ref, setState: setState, context: context);
    viewModel.init();
    RechargeUtil.rechargeBottomSheet = true;
  }

  @override
  void dispose() {
    viewModel.dispose();
    RechargeUtil.rechargeBottomSheet = false;
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }


  @override
  Widget build(BuildContext context) {
    _appTextTheme = _theme.getAppTextTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appLinearGradientTheme= _theme.getAppLinearGradientTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color:_appColorTheme.appBarBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, left: 16.0, right: 16.0, bottom: 0),
              child: Column(
                children: [
                  _buildAppBar(),
                  SizedBox(height: 14.h),
                  _buildBannerView(),
                  SizedBox(height: 12.h),
                  _buildTitle(),
                  SizedBox(height: 9.h),
                  _buildRechargeCoinsList(),
                  const SizedBox(height: 4),
                  Visibility(
                      visible: Platform.isAndroid,
                      child: _buildRechargeTitle('请选择支付方式')),
                  Visibility(
                      visible: Platform.isAndroid,
                      child: SizedBox(height: 4.h)),
                  Visibility(
                      visible: Platform.isAndroid,
                      child: _buildRechargePlatforms()),
                  Visibility(
                      visible: Platform.isAndroid,
                      child: _buildAndroidRechargeButton()),
                  Visibility(
                      visible: Platform.isIOS,
                      child: _buildIosRechargeButton()),
                ],
              )),
        ));
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 24.w,),
        Center(child: Text('充值', style:_appTextTheme.appbarTextStyle)),
        InkWell(
          onTap: () => viewModel.checkQuitDialog(),
          child:ImgUtil.buildFromImgPath(_appImageTheme.bottomSheetCancelBtnIcon, size: 24.w),
        )
      ],
    );
  }

  Widget _buildBannerView() {
    return const BannerView(
      padding: EdgeInsets.all(0),
      locatedPageFilter: 2,
      aspectRatio: 3.43,
    );
  }

  Widget _buildTitle(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRechargeTitle('请选择充值金币'),
        _buildMyCoins(),
      ],
    );
  }

  Widget _buildMyCoins() {
    return Row(
      children: [
        Text('馀额', style:_appTextTheme.rechargeCoinTitleTextStyle),
        SizedBox(width: 8.w),
        ImgUtil.buildFromImgPath(_appImageTheme.iconCoin, size: 16.w),
        Text('${viewModel.myCoin.toInt()}', style:_appTextTheme.rechargeCoinTitleTextStyle),
      ],
    );
  }

  Widget _buildRechargeTitle(String title){
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: _appTextTheme.rechargeCoinTitleTextStyle, textAlign: TextAlign.left),
    );
  }

  Widget _buildRechargeCoinsList(){
    return Consumer(builder: (context, ref, _){
      final List<DepositOptionListInfo> phraseList = ref.watch(userInfoProvider).depositNumberOption?.list ?? [];
      return Expanded(
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 8.0,
            ),
            itemCount: phraseList.length,
            itemBuilder: (BuildContext context, int index, ) {
              return _buildRechargeCoinButton(phraseList[index], index);
            }
        ),
      );
    });
  }

  Widget _buildRechargeCoinButton(DepositOptionListInfo item, int index){
    final coins = item.coins ?? 0;
    final amount = item.amount ?? 0;
    return GestureDetector(
      onTap: () => viewModel.rechargeCoinsHandler(item),
      child: Container(
        decoration: viewModel.selectPhraseOption == item
          ? _appBoxDecorationTheme.rechargeCellSelectBoxDecoration
          : _appBoxDecorationTheme.rechargeCellBoxDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImgUtil.buildFromImgPath(_appImageTheme.iconCoin, size: 16.w),
                const SizedBox(width: 2),
                Text('$coins', style:  _appTextTheme.rechargeCoinTitleTextStyle)
              ],
            ),
            Text('￥$amount', style:_appTextTheme.rechargeCoinSubTitleTextStyle)
          ],
        ),
      ),
    );
  }

  Widget _buildRechargePlatforms(){

    return Row(
      children: [
        Expanded(child: _buildRechargePlatform('支付宝', 'assets/strike_up_list/pay_1.png', 1)),
        const SizedBox(width: 4),
        Expanded(child: _buildRechargePlatform('微信支付', 'assets/strike_up_list/pay_2.png', 0)),
      ],
    );
  }

  Widget _buildRechargePlatform(String platformTitle, String platformImgPath, int type){

    return GestureDetector(
      onTap: () => viewModel.rechargePlatformHandler(type),
      child: Container(
          height: 46,
          decoration: type == viewModel.selectRechargeType
              ? _appBoxDecorationTheme.cellSelectBoxDecoration
              : _appBoxDecorationTheme.cellBoxDecoration,
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Image.asset(platformImgPath, width: 24, height: 24),
                    const SizedBox(width: 8),
                    Text(platformTitle, style: _appTextTheme.rechargeCoinTitleTextStyle),
                  ],
                ),
                type == viewModel.selectRechargeType
                    ? ImgUtil.buildFromImgPath(_appImageTheme.checkBoxTrueIcon, size: 24)
                    : ImgUtil.buildFromImgPath(_appImageTheme.checkBoxFalseIcon, size: 24)
              ],
            ),
          )
      ),
    );
  }

  Widget _buildAndroidRechargeButton(){
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: SizedBox(
        height: 48,
        child: GradientButton(
          text: '立即充值',
          textStyle: _appTextTheme.buttonPrimaryTextStyle,
          radius: 24,
            gradientColorBegin: _appLinearGradientTheme.buttonPrimaryColor.colors[0],
            gradientColorEnd: _appLinearGradientTheme.buttonPrimaryColor.colors[1],
          height: 44,
          onPressed: () => ref.read(appPaymentManagerProvider).memberRecharge(context, rechargeType: viewModel.selectRechargeType ?? 0, selectPhraseOption: viewModel.selectPhraseOption)
        ),
      ),
    );
  }

  Widget _buildIosRechargeButton(){

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: SizedBox(
        height: 48,
        child: GradientButton(
            text: '立即充值',
            textStyle:  _appTextTheme.buttonPrimaryTextStyle,
            radius: 24,
            gradientColorBegin:  _appLinearGradientTheme.buttonPrimaryColor.colors[0],
            gradientColorEnd:  _appLinearGradientTheme.buttonPrimaryColor.colors[1],
            height: 44,
            onPressed: () => ref.read(appPaymentManagerProvider).memberRecharge(context, rechargeType: 2, selectPhraseOption: viewModel.selectPhraseOption)
        ),
      ),
    );
  }
}