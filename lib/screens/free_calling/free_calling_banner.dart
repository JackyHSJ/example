import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frechat/system/providers.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/repository/response_code.dart';

import 'package:frechat/models/ws_req/mission/ws_mission_get_award_req.dart';
import 'package:frechat/widgets/shared/img_util.dart';


class FreeCallingBanner extends ConsumerStatefulWidget {

  const FreeCallingBanner({
    super.key,
  });

  @override
  ConsumerState<FreeCallingBanner> createState() => _FreeCallingBannerState();
}

class _FreeCallingBannerState extends ConsumerState<FreeCallingBanner> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildBanner(),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImgUtil.buildFromImgPath('assets/free_calling/icon_uncheck.png', width: 24, height: 24),
            SizedBox(width: 4),
            Text('今日不再显示', style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              decoration: TextDecoration.none,
              height: 1
            ),),
          ],
        ),
        SizedBox(height: 24),
        GestureDetector(
            onTap: () => Navigator.pop(context),
            child: _buildCancelButton()
        )
      ],
    );
  }

  Widget _buildCancelButton(){
    return Image.asset('assets/strike_up_list/Cancel.png', width: 36, height: 36);
  }

  Widget _buildBanner(){
    return Image.asset('assets/free_calling/banner_ad.png', width: 320, height: 450, fit: BoxFit.contain);
  }


}