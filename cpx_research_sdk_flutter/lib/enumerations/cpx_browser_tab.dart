/*
 * cpx_browser_tab.dart
 * CPX Research
 *
 * Created by Dennis Kossmann on 29.9.2024.
 * Copyright © 2024. All rights reserved.
 */

import 'package:cpx_research_sdk_flutter/utils/cpx_network_service.dart';
import 'package:flutter/material.dart';

/// The [CPXBrowserTab] enum defines the navigation tabs of the browser
enum CPXBrowserTab {
  home,
  help,
  minimize,
  close;

  IconData get icon {
    switch (this) {
      case CPXBrowserTab.home:
        return Icons.home_outlined;
      case CPXBrowserTab.help:
        return Icons.help_outline;
      case CPXBrowserTab.minimize:
        return Icons.minimize;
      case CPXBrowserTab.close:
        return Icons.close;
    }
  }

  int get pageIndex {
    switch (this) {
      case CPXBrowserTab.home:
        return 0;
      case CPXBrowserTab.help:
        return 1;
      case CPXBrowserTab.minimize:
        return 2;
      case CPXBrowserTab.close:
        return 3;
    }
  }

  Uri get url {
    switch (this) {
      case CPXBrowserTab.help:
        return CPXNetworkService().getHelpURL();
      case CPXBrowserTab.home:
      case CPXBrowserTab.minimize:
      case CPXBrowserTab.close:
        return CPXNetworkService().getHomeURL();
    }
  }
}
