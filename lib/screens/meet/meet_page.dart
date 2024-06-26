
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/member/ws_member_fate_recommend_res.dart';
import 'package:frechat/screens/meet/meet_card.dart';
import 'package:frechat/screens/meet/meet_card_view_model.dart';
import 'package:frechat/screens/meet/meet_page_view_model.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/tag_text.dart';
import 'package:frechat/widgets/theme/original/app_box_decoration.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/original/app_texts.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

/// Home 的 4 個 tab 其中之一:
/// 使用者動態瀏覽器頁
class MeetPage extends ConsumerStatefulWidget {
  const MeetPage({super.key});

  @override
  ConsumerState<MeetPage> createState() => _MeetPageState();
}

class _MeetPageState extends ConsumerState<MeetPage> with AutomaticKeepAliveClientMixin {
  late MeetPageViewModel viewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    viewModel = MeetPageViewModel(ref: ref, setState: setState);
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
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: false,
      padding: EdgeInsets.only(top: paddingHeight, right: WidgetValue.horizontalPadding, left: WidgetValue.horizontalPadding),
      appBar: const MainAppBar(title: '汪遇'),
      child: _buildStackCard(),
    );
  }

  _buildStackCard() {
    return Consumer(builder: (context, ref, _) {
      final List<FateListInfo> list = ref.watch(userInfoProvider).meetCardRecommendList?.list ?? [];
      return list.isEmpty ? _buildEmpty() : Stack(
        children: list.map((info) => MeetCard(
          key: UniqueKey(),
          fateListInfo: info,
          onPressBtn: () => viewModel.removeTopRecommend(list),
        )).toList(),
      );
    });
  }

  Widget _buildEmpty() {
    return LoadingAnimation.discreteCircle();
  }
}
