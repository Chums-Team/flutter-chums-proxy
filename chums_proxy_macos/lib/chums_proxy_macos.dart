import 'dart:ui';

import 'package:chums_proxy/chums_proxy.dart';

class ChumsProxyMacos extends ChumsProxyPlatform {
  static void registerWith() {
    ChumsProxyPlatform.instance = ChumsProxyMacos();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  Future<void> initDyLib() async {
    throw UnimplementedError('initDyLib() has not been implemented.');
  }
}
