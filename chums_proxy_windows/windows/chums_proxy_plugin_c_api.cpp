#include "include/chums_proxy/chums_proxy_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "chums_proxy_plugin.h"

void ChumsProxyPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  chums_proxy::ChumsProxyPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
