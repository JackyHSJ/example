import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';

import 'package:frechat/screens/profile/edit/personal_edit_view_model.dart';

import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';

import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class PersonalEditAlbumCell extends ConsumerStatefulWidget {

  final EditImgModel model;
  final Function()? onPress;
  final bool showDeleteButton;
  final Function()? onDeletePress;

  const PersonalEditAlbumCell({
    super.key,
    required this.model,
    this.onPress,
    this.showDeleteButton = false,
    this.onDeletePress
  });

  @override
  ConsumerState<PersonalEditAlbumCell> createState() => _PersonalEditImgCellState();
}

class _PersonalEditImgCellState extends ConsumerState<PersonalEditAlbumCell> {
  EditImgModel get model => widget.model;
  late AppTheme _theme;
  late AppLinearGradientTheme _linearGradientTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppImageTheme _appImageTheme;

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _linearGradientTheme = _theme.getAppLinearGradientTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    _appImageTheme = _theme.getAppImageTheme;

    return GestureDetector(
      onTap: widget.onPress,
      child: (model.type == ImgType.none)
          ? Container(
              decoration: _appBoxDecorationTheme.albumCellBoxDecoration,
              child: Center(
                child: ImgUtil.buildFromImgPath(_appImageTheme.iconAddFile, size: 36.w),
              )
            )
          : _buildImg(),
    );
  }

  _buildImg() {
    return (model.type == ImgType.urlPath) ? _buildUrlImg() : _buildSelectImg();
  }

  _buildUrlImg() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: AppColors.dividerGrey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: AvatarUtil.userAvatar(model.path, size: double.infinity)
        ),

        // 審核中標籤
        Visibility(
          visible: (model.albumsPathInfo != null &&
              model.albumsPathInfo?.status != 1),
          child: Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: 2, horizontal: WidgetValue.separateHeight),
              decoration: BoxDecoration(
                gradient: _linearGradientTheme.verifyTagBackgroundColor,
                borderRadius: BorderRadius.circular(WidgetValue.btnRadius),
              ),
              child: const Text('审核中',
                  style: TextStyle(color: AppColors.textWhite)),
            ),
          ),
        ),

        // 删除標籤
        Visibility(
          visible: widget.showDeleteButton,
          child: Positioned(
            bottom: 8,
            right: 8,
            child: ClipOval(
              child: Material(
                color: AppColors.btnLightGrey, // Button color
                child: GestureDetector(
                  onTap: widget.onDeletePress,
                  child: const SizedBox(
                    width: 28,
                    height: 28,
                    child: Icon(
                      Icons.close,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildSelectImg() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: AppColors.dividerGrey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: AvatarUtil.fileAvatar(File(model.path), size: double.infinity)
        ),

        // 删除標籤
        Visibility(
          visible: widget.showDeleteButton,
          child: Positioned(
            bottom: 8,
            right: 8,
            child: ClipOval(
              child: Material(
                color: AppColors.btnLightGrey, // Button color
                child: GestureDetector(
                  onTap: widget.onDeletePress,
                  child: const SizedBox(
                    width: 28,
                    height: 28,
                    child: Icon(
                      Icons.close,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // 上傳標籤
        Visibility(
          visible: model.type == ImgType.filePath,
          child: const Positioned(
            top: 8,
            left: 8,
            child: SizedBox(
              width: 28,
              height: 28,
              child: Icon(
                Icons.upload,
                color: AppColors.mainPink,
                size: 32,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
