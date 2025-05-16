import 'dart:ui';

import 'package:chums_proxy/chums_proxy.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'dart:ffi' as ffi;

class ChumsProxyAndroid extends ChumsProxyPlatform {
  /// Constructs a ChumsProxyPlatform.
  static void registerWith() {
    ChumsProxyPlatform.instance = ChumsProxyAndroid();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // On android we need to stop the proxy every time the application is detached
    if(state == AppLifecycleState.detached) {
      try {
        stopProxy();
      } catch (err, stackTrace) {
        debugPrint(err.toString());
      }
    }
  }

  // Loading the library
  @override
  Future<void> initDyLib() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if(androidInfo.supportedAbis.contains('arm64-v8a')) {
      dyLib = ffi.DynamicLibrary.open('libchums_proxy.so');
    } else {
      debugPrint('[Proxy]: Unsupported Android architecture: ${androidInfo.supportedAbis}');
    }
  }
}
