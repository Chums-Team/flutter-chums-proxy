#ifndef FLUTTER_PLUGIN_CHUMS_PROXY_PLUGIN_H_
#define FLUTTER_PLUGIN_CHUMS_PROXY_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace chums_proxy {

class ChumsProxyPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ChumsProxyPlugin();

  virtual ~ChumsProxyPlugin();

  // Disallow copy and assign.
  ChumsProxyPlugin(const ChumsProxyPlugin&) = delete;
  ChumsProxyPlugin& operator=(const ChumsProxyPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace chums_proxy

#endif  // FLUTTER_PLUGIN_CHUMS_PROXY_PLUGIN_H_
