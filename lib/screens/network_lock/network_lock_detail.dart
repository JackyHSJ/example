import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class NetworkLockDetail extends ConsumerStatefulWidget {
  const NetworkLockDetail({
    Key? key,
  }) : super(key: key);

  @override
  _NetworkLockDetailState createState() => _NetworkLockDetailState();
}

class _NetworkLockDetailState extends ConsumerState<NetworkLockDetail> {
  @override
  Widget build(BuildContext context) {
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    return MainScaffold(
      padding: EdgeInsets.only(top: paddingHeight),
      isFullScreen: true,
      needSingleScroll: false,
      appBar: const MainAppBar(title: '网络诊断'),
      child: const Column(
        children: [
          Text('网络诊断会自动检测您当前的网络情况，请耐心等待')
        ],
      ),
    );
  }

  _buildInfoList() {

  }
}