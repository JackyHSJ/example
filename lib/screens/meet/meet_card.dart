
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/member/ws_member_fate_recommend_res.dart';
import 'package:frechat/screens/meet/meet_card_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/dialog_util.dart';
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_box_decoration.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

/// Home 的 4 個 tab 其中之一:
/// 使用者動態瀏覽器頁
class MeetCard extends ConsumerStatefulWidget {
  const MeetCard({super.key, required this.onPressBtn, required this.fateListInfo});

  final Function() onPressBtn;
  final FateListInfo fateListInfo;
  @override
  ConsumerState<MeetCard> createState() => _MeetCardState();
}

class _MeetCardState extends ConsumerState<MeetCard> with TickerProviderStateMixin {
  late MeetCardViewModel viewModel;
  FateListInfo get fateListInfo => widget.fateListInfo;

  @override
  void initState() {
    viewModel = MeetCardViewModel(ref: ref, setState: setState, tickerProvider: this);
    viewModel.init(
      onShowRealPersonDialog: () => _showRealPersonDialog(),
      onShowRechargeDialog: () => _showRechargeDialog()
    );
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSlider();
  }

  Widget _buildSlider() {
    return SlideTransition(
      position: viewModel.slideAnimation!,
      child: _buildCard(),
    );
  }

  Widget _buildCard() {
    return Container(
      key: UniqueKey(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(WidgetValue.btnRadius),
        image: DecorationImage(
          image: AssetImage(viewModel.backgroundImg),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding, horizontal: WidgetValue.horizontalPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: _buildMateInfo()),
            _buildActionButton()
          ],
        ),
      ),
    );
  }

  Widget _buildMateInfo() {
    String intro = '${fateListInfo.nickName}';
    final num age = fateListInfo.age ?? 0;
    final num weight = fateListInfo.weight ?? 0;
    if(age != 0) intro = '$intro $age岁';
    if(weight != 0) intro = '$intro ${weight}kg';

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Text(intro, style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600, fontSize: 18)),
        ),
        Row(
          children: [
            _buildTagText(fateListInfo.hometown ?? ''),
            _buildTagText(fateListInfo.occupation ?? ''),
          ],
        )
      ],
    );
  }

  Widget _buildTagText(String text) {
    return Visibility(
      visible: text != '',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
        margin: EdgeInsets.only(right: 4.w),
        decoration: AppBoxDecoration.tagTextBoxDecoration,
        child: Text(
          text,
          style: const TextStyle(color: AppColors.textBlack, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildCancelBtn(),
        _buildLikeBtn()
      ],
    );
  }

  Widget _buildLikeBtn() {
    return CommonButton(
        btnType: CommonButtonType.icon,
        cornerType: CommonButtonCornerType.circle,
        isEnabledTapLimitTimer: true,
        width: WidgetValue.monsterIcon,
        height: WidgetValue.monsterIcon,
        iconWidget: ImgUtil.buildFromImgPath('assets/meet_card/meet_card_btn_like.png'),
        onTap: () async {
          await viewModel.pressLike(
            fateListInfo,
            onStartMask: () => LoadingAnimation.showOverlayMask(context),
            onStopMask: () => LoadingAnimation.cancelOverlayLoading()
          );
          widget.onPressBtn();
        }
    );
  }

  Widget _buildCancelBtn() {
    return CommonButton(
        btnType: CommonButtonType.icon,
        cornerType: CommonButtonCornerType.circle,
        isEnabledTapLimitTimer: true,
        width: WidgetValue.bigIcon,
        height: WidgetValue.bigIcon,
        iconWidget: ImgUtil.buildFromImgPath('assets/meet_card/meet_card_btn_unlike.png'),
        onTap: () async {
          await viewModel.pressCancel(
            onStartMask: () => LoadingAnimation.showOverlayMask(context),
            onStopMask: () => LoadingAnimation.cancelOverlayLoading()
          );
          widget.onPressBtn();
        }
    );
  }

  /// 真人認證彈窗
  void _showRealPersonDialog(){
    final currentContext = BaseViewModel.getGlobalContext();
    DialogUtil.popupRealPersonDialog(
        theme: AppTheme(themeType: AppThemeType.original), context: currentContext, description: '您还未通过真人认证与实名认证，认证完毕后方可传送心动 / 搭讪'
    );
  }

  /// 充值彈窗
  void _showRechargeDialog() {
    // 充值次數
    final num rechargeCounts =  ref.read(userInfoProvider).memberPointCoin?.depositCount ?? 0;
    // 如果充值次數為 0
    if (rechargeCounts == 0) {
      RechargeUtil.showFirstTimeRechargeDialog('余额不足，请先充值'); // 開啟首充彈窗
    } else {
      RechargeUtil.showRechargeBottomSheet(theme: AppTheme(themeType: AppThemeType.original)); // 開啟充值彈窗
    }
  }
}
