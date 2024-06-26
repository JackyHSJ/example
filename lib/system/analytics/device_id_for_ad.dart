
import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
// import 'package:device_identity/device_identity.dart';

class DeviceIdForAd {

  static Future<String> getIdfaOrCaid() async {
    String deviceUuid = '';
    final bool isIOS = Platform.isIOS;
    if(isIOS == true) {
      /// get iOS IDFA
      deviceUuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    }
    if(isIOS == false) {
      /// get Android OAID
      // await DeviceIdentity.register();
      // deviceUuid = await DeviceIdentity.oaid;
    }
    return deviceUuid;
  }
}