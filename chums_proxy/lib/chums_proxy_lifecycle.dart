import 'chums_proxy.dart';
import 'package:flutter/material.dart';

// A class for managing the proxy lifecycle
class ChumsProxyLifecycle with WidgetsBindingObserver {
  late final ChumsProxyPlatform chumsProxy;

  bool _started = false;

  ChumsProxyLifecycle() {
    chumsProxy = ChumsProxyPlatform.instance;
    WidgetsBinding.instance.addObserver(this);
  }


  // Start proxy lifecycle management and proxy
  start() {
    try {
      chumsProxy.startProxy();
      _started = true;
    } catch (err, stackTrace) {
      debugPrint(err.toString());
    }
  }

  // Stop proxy lifecycle management and proxy
  stop() {
    try {
      _started = false;
      chumsProxy.stopProxy();
    } catch (err, stackTrace) {
      debugPrint(err.toString());
    }
  }

  // Responding to changes in the state of the application.
  // The implementation depends on the platform
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(_started) {
      chumsProxy.didChangeAppLifecycleState(state);
    }
  }

  dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }


}
