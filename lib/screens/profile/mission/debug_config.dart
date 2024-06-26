


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/models/device_platform_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';

class DebugConfig extends ConsumerStatefulWidget {
  const DebugConfig({super.key});

  @override
  ConsumerState<DebugConfig> createState() => _DebugConfigState();
}

class _DebugConfigState extends ConsumerState<DebugConfig> {

  num? callType;
  num? officialType;
  num? intimacyType;
  num? tvWallType;
  num? mateType;
  num? withdrawType;
  num? type7;
  num? activityType;
  num? gmType;
  num? blockType;
  AppEnvType? env;
  String? merchant;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getData() async {
    callType = ref.read(userInfoProvider).buttonConfigList?.callType;
    officialType = ref.read(userInfoProvider).buttonConfigList?.officialType;
    intimacyType = ref.read(userInfoProvider).buttonConfigList?.intimacyType;
    tvWallType = ref.read(userInfoProvider).buttonConfigList?.tvWallType;
    mateType = ref.read(userInfoProvider).buttonConfigList?.mateType;
    withdrawType = ref.read(userInfoProvider).buttonConfigList?.withdrawType;
    type7 = ref.read(userInfoProvider).buttonConfigList?.type7;
    activityType = ref.read(userInfoProvider).buttonConfigList?.activityType;
    gmType = ref.read(userInfoProvider).buttonConfigList?.gmType;
    blockType = ref.read(userInfoProvider).buttonConfigList?.blockType;
    env = AppConfig.env;
    merchant = await DevicePlatformModel.getDeviceNameForMerchant();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromRGBO(255, 218, 191, 0.8),
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios),
            ),
            title: const Text('config',
                style: TextStyle(fontSize: 16, color: Color.fromRGBO(68, 70, 72, 1), fontWeight: FontWeight.w600)), centerTitle: true),
        body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildConfig(),
            )
        )
    );
  }


  Widget _buildConfig() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('callType: ${callType}'),
          Text('officialType: ${officialType}'),
          Text('intimacyType: ${intimacyType}'),
          Text('tvWallType: ${tvWallType}'),
          Text('mateType: ${mateType}'),
          Text('withdrawType: ${withdrawType}'),
          Text('type7: ${type7}'),
          Text('activityType: ${activityType}'),
          Text('gmType: ${gmType}'),
          Text('blockType: ${blockType}'),
          Text('-------------------------'),
          Text('env: ${env}'),
          Text('merchant: ${merchant}'),
        ]
    );
  }
}



