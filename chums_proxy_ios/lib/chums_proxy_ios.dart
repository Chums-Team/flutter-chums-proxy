import 'dart:ui';

import 'package:chums_proxy/chums_proxy.dart';
import 'package:flutter/foundation.dart';
import 'dart:ffi' as ffi;

class ChumsProxyIos extends ChumsProxyPlatform {
  static void registerWith() {
    ChumsProxyPlatform.instance = ChumsProxyIos();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // On IOS We need to stop the proxy every time the application is detached or paused
    if(state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      try {
        stopProxy();
      } catch (err, stackTrace) {
        debugPrint(err.toString());
      }
    } else if(state == AppLifecycleState.resumed){
      // And start if application resumed
      try {
        startProxy();
      } catch (err, stackTrace) {
        debugPrint(err.toString());
      }
    }
  }

  @override
  Future<void> initDyLib() async {
    debugPrint('[Proxy] Load library framework on IOS');
    try {
      dyLib = ffi.DynamicLibrary.open('libevernameproxy.framework/libevernameproxy');
    } on Object catch(e, stackTrace) {
      debugPrint('[Proxy] open library (libevernameproxy) on IOS error: $e');
      dyLib = ffi.DynamicLibrary.process();
    }

    debugPrint('[Proxy] load result: $dyLib');
  }
}
