

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/screens/activity/activity_post_detail.dart';
import 'package:frechat/screens/activity/add/activity_add_post.dart';
import 'package:frechat/screens/activity/tab/city/activity_city_tab_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/activity/cell/activity_post_cell.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/divider.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

class ActivityCityTab extends ConsumerStatefulWidget {
  const ActivityCityTab({super.key});

  @override
  ConsumerState<ActivityCityTab> createState() => _ActivityCityTabState();
}

class _ActivityCityTabState extends ConsumerState<ActivityCityTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late ActivityCityTabViewModel viewModel;

  @override
  void initState() {
    viewModel = ActivityCityTabViewModel(setState: setState, ref: ref);
    viewModel.init();
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _){
      final String location = ref.watch(userInfoProvider).memberInfo?.location ?? '';
      // return location == '' ? _buildEmptyLocationWidget() : _buildPostList();
      return _buildPostList();
    });
  }

  Widget _buildPostList() {
    return Consumer(builder: (context, ref, _){
      final List<ActivityPostInfo> list = ref.watch(userInfoProvider).activitySearchInfoCity?.list ?? [];
      final List<dynamic> likeList = ref.watch(userInfoProvider).activityAllLikePostIdList ?? [];
      return CustomList.separatedList(
        separator: MainDivider(weight: 2, color: AppColors.mainLightGrey, height: WidgetValue.verticalPadding * 3),
        childrenNum: list.length,
        children: (context, index) {
          // return ActivityCityCell(postInfo: list[index], likeList: likeList);
          return InkWell(
            child: ActivityPostCell(postInfo: list[index], likeList: likeList,onTap: (){},onTapMessageButton: (){},),
            onTap: () => BaseViewModel.pushPage(context, ActivityPostDetail(postInfo: list[index])),
          );
        }
      );
    });
  }

  Widget _buildEmptyLocationWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImgUtil.buildFromImgPath('assets/images/image_cohesion_empty.png', size: 150.w),
        SizedBox(height:23.h),
        Text('开启定位', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp,color: AppColors.textFormBlack)),
        Text('开启定位功能才可以看到同城动态', style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12.sp,color: AppColors.textFormBlack)),
        SizedBox(height:24.h),
        _buildBtn()
      ],
    );
  }

  Widget _buildBtn() {
    return CommonButton(
        btnType: CommonButtonType.text,
        cornerType: CommonButtonCornerType.circle,
        isEnabledTapLimitTimer: false,
        width: 148.w,
        height: 44.h,
        text: '开启定位',
        textStyle: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w500,fontSize: 14.sp),
        colorBegin: AppColors.mainPink,
        colorEnd: AppColors.mainPetalPink,
        onTap: () => openAppSettings());
  }

}