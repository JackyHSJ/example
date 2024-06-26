import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/frechat.dart';
import 'package:frechat/system/notification/zpns/zpns_service.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:zego_zpns/zego_zpns.dart';

void main() {

  ///状态列透明
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent
  ));

  runZonedGuarded(() {
    runApp(const ProviderScope(
        child: OverlaySupport(
          child: FreChat(),
        )
    ));
  }, (error, stackTrace) {
    print(stackTrace);
  }, zoneSpecification: ZoneSpecification(
      print: (Zone self, ZoneDelegate parent, Zone zone, String message){
        /**
         * Print only in debug mode
         * */
        if (kDebugMode) {
          parent.print(zone, "wrapped content=$message");
        }
      }));
}