
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/cat/cat_videos/model/videos_model.dart';
import 'package:frechat/screens/cat/cat_videos/videos_wall_cell_view_model.dart';
import 'package:frechat/screens/user_info_view/user_info_view_report_view.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/divider.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideosWallCell extends ConsumerStatefulWidget {
  const VideosWallCell({super.key, required this.model});
  final VideosModel model;
  @override
  ConsumerState<VideosWallCell> createState() => _VideosWallCellState();
}

class _VideosWallCellState extends ConsumerState<VideosWallCell> {
  late VideosWallCellViewModel viewModel;
  VideosModel get model => widget.model;
  @override
  void initState() {
    viewModel = VideosWallCellViewModel(setState: setState, ref: ref);
    viewModel.init(context);
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildVideo();
  }

  Widget _buildVideo() {
    final Widget videoWidget = viewModel.playerUtil?.buildVideoPlayer() ?? const SizedBox();
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: UIDefine.getWidth(),
          height: UIDefine.getHeight(),
          child: videoWidget
        ),
        _userInfo(),
        _buildPlayVideoBtn(),
        Positioned( right:12,top:MediaQuery.of(context).padding.top+8,child:  _buildReportBtn())
      ],
    );
  }

  _buildPlayVideoBtn() {
    final bool isPlay = viewModel.isPlay();
    final IconData? icon = isPlay ? null : Icons.play_circle_fill_outlined;
    return GestureDetector(
      onTap: () => isPlay ? viewModel.pause() : viewModel.play(),
      child: icon == null ? SizedBox() : Icon(icon, size: WidgetValue.monsterIcon, color: AppColors.mainGrey),
    );
  }

  _userInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding, vertical: WidgetValue.verticalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildAvatar(),
              SizedBox(width: WidgetValue.separateHeight),
              _buildName(),
              SizedBox(width: WidgetValue.separateHeight),
              _buildSubscribeBtn()
            ],
          ),
          SizedBox(height: WidgetValue.separateHeight),
          _buildTitle(),
          SizedBox(height: WidgetValue.separateHeight),
          _buildDes()
        ],
      ),
    );
  }

  _buildAvatar() {
    final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    return model.avatarPath.isEmpty
    ? ClipOval(child: BaseViewModel.maleOrFemaleAvatarWidget(gender, size: WidgetValue.bigIcon))
    : ImgUtil.buildFromImgPath(model.avatarPath);
  }

  _buildName() {
    return Text('@${model.name}', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600, fontSize: 18));
  }

  _buildSubscribeBtn() {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding, vertical: WidgetValue.separateHeight),
        decoration: BoxDecoration(
          color: AppColors.whiteBackGround,
          borderRadius: BorderRadius.circular(WidgetValue.btnRadius)
        ),
        child: Text('訂閱', style: TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }

  _buildReportBtn() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserInfoViewReportView(
              userId: 0,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding, vertical: WidgetValue.separateHeight),
        decoration: BoxDecoration(
            color: Color.fromRGBO(0,0,0,0.2),
            borderRadius: BorderRadius.circular(WidgetValue.btnRadius)
        ),
        child: Text('举报', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.sp,color:  Color.fromRGBO(255,255,255,1))),
      ),
    );
  }

  _buildTitle() {
    return Row(
      children: [
        Icon(Icons.arrow_right, size: WidgetValue.smallestIcon, color: AppColors.textWhite),
        Text(model.title, style: TextStyle(color: AppColors.textWhite))
      ],
    );
  }

  _buildDes() {
    return Text(model.des, style: TextStyle(color: AppColors.textWhite));
  }
}