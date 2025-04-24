import 'dart:ffi' as ffi;
import 'dart:ui';
import 'package:ffi/ffi.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

typedef StartFunctionType = ffi.Pointer<ffi.Void> Function(ffi.Pointer<Utf8>, ffi.Uint16, ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);
typedef StartFunctionTypeDart = ffi.Pointer<ffi.Void> Function(ffi.Pointer<Utf8>, int, ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

typedef StopFunctionType = ffi.Void Function(ffi.Pointer<ffi.Void>);
typedef StopFunctionTypeDart = void Function(ffi.Pointer<ffi.Void>);


//A class for interacting with the native proxy library
abstract class ChumsProxyPlatform extends PlatformInterface {
  /// Constructs a ChumsProxyPlatform.
  ChumsProxyPlatform() : super(token: _token);

  static final Object _token = Object();

  static ChumsProxyPlatform _instance = _ChumsProxyPlaceholder();

  /// The default instance of [ChumsProxyPlatform] to use.
  ///
  /// Defaults to [_ChumsProxyPlaceholder].
  static ChumsProxyPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ChumsProxyPlatform] when
  /// they register themselves.
  static set instance(ChumsProxyPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  final proxyPort = 3000;
  final proxyHost = InternetAddress.loopbackIPv4.address;
  ffi.DynamicLibrary? dyLib;
  StopFunctionTypeDart? _stopFunction;
  StartFunctionTypeDart? _startFunction;
  late final ffi.Pointer<Utf8> _host = proxyHost.toNativeUtf8();
  final ffi.Pointer<Utf8> _logLevel = 'info'.toNativeUtf8();
  ffi.Pointer<Utf8>? _cacheDir;
  ffi.Pointer<Utf8>? _stateDir;
  ffi.Pointer<ffi.Void>? _stopFunctionPointer;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool _startInit = false;
  bool _endInit = false;
  bool _started = false;

  // The library connection process depends on the platform.
  Future<void> initDyLib();

  // The life cycle of a proxy depends on the platform
  void didChangeAppLifecycleState(AppLifecycleState state);

  // Initializing the proxy library
  Future<void> _initLibrary() async {
    try {
      debugPrint('[Proxy] init');
      if(_startInit) {
        return;
      }
      _startInit = true;
      await initDyLib();

      if(dyLib == null) {
        return;
      }
      _startFunction ??= dyLib?.lookupFunction<StartFunctionType, StartFunctionTypeDart>('start_server_ffi');
      _stopFunction ??= dyLib?.lookupFunction<StopFunctionType, StopFunctionTypeDart>('stop_server_ffi');
      final appDocDir = await getApplicationDocumentsDirectory();
      _stateDir ??= appDocDir.path.toNativeUtf8();
      final appCacheDir = await getApplicationCacheDirectory();
      _cacheDir ??= appCacheDir.path.toNativeUtf8();
    } on Object catch(e, stackTrace) {
      debugPrint('[Proxy] init error: $e');
    } finally {
      _endInit = true;
    }
  }

  // Start proxy service
  Future<void> startProxy() async {
    if(_started) {
      return;
    }
    _started = true;
    if(!_startInit) {
      await _initLibrary();
    }
    if(_endInit) {
      if(dyLib == null || _startFunction == null || _stateDir == null || _cacheDir == null) {
        return;
      }
      try {
        debugPrint('[Proxy] startProxy');
        _stopFunctionPointer = _startFunction!(_host, proxyPort, _logLevel, _stateDir!, _cacheDir!);
      } catch(e, stackTrace) {
        debugPrint(e.toString());
      }
    }
  }

  // Start proxy service
  void stopProxy() {
    if(!_started) {
      return;
    }
    _started = false;
    if(dyLib == null || _stopFunction == null || _stopFunctionPointer == null) {
      return;
    }
    try {
      debugPrint('[Proxy] stopProxy');
      _stopFunction!(_stopFunctionPointer!);
      _stopFunctionPointer = null;
    } catch(e, stackTrace) {
      debugPrint(e.toString());
    }
  }
}

class _ChumsProxyPlaceholder extends ChumsProxyPlatform {

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
  }

  @override
  Future<void> initDyLib() {
    throw UnimplementedError();
  }

}
