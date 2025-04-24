import 'dart:ui';

import 'package:chums_proxy/chums_proxy.dart';

class ChumsProxyLinux extends ChumsProxyPlatform {
  static void registerWith() {
    ChumsProxyPlatform.instance = ChumsProxyLinux();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  Future<void> initDyLib() async {
    throw UnimplementedError('initDyLib() has not been implemented.');
  }
}
