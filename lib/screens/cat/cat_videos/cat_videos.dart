

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/cat/cat_videos/cat_videos_view_model.dart';
import 'package:frechat/screens/cat/cat_videos/videos_wall_cell.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:flutter_screenutil/src/size_extension.dart';

class CatVideos extends ConsumerStatefulWidget {
  const CatVideos({super.key});

  @override
  ConsumerState<CatVideos> createState() => _CatVideosState();
}

class _CatVideosState extends ConsumerState<CatVideos> {
  late CatVideosViewModel viewModel;

  @override
  void initState() {
    viewModel = CatVideosViewModel(ref: ref, setState: setState);
    // viewModel.init();
    super.initState();
  }

  @override
  void dispose() {
    // viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      padding: EdgeInsets.zero,
      isFullScreen: true,
      needSingleScroll: false,
      floatingActionButtonLocation: null,
      backgroundColor: const Color.fromRGBO(239, 234, 215, 1),
      child: _buildPageVideo(),
    );
  }

  _buildPageVideo() {
    return PageView(
      scrollDirection: Axis.vertical,
      children: viewModel.videosList.map((video) => VideosWallCell(model: video)).toList(),
    );
  }
}