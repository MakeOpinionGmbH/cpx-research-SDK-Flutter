/*
 * cpx_browser_view.dart
 * CPX Research
 *
 * Created by Dennis Kossmann on 22.7.2021.
 * Copyright © 2021. All rights reserved.
 */

import 'dart:io';

import 'package:cpx_research_sdk_flutter/cpx_controller.dart';
import 'package:cpx_research_sdk_flutter/enumerations/cpx_browser_tab.dart';
import 'package:cpx_research_sdk_flutter/utils/cpx_logger.dart';
import 'package:cpx_research_sdk_flutter/utils/cpx_network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CPXBrowserView extends StatefulWidget {
  final CPXBrowserTab currentTab;
  final Function()? onClose;

  CPXBrowserView(this.currentTab, {this.onClose});

  @override
  _CPXBrowserViewState createState() => _CPXBrowserViewState();
}

class _CPXBrowserViewState extends State<CPXBrowserView> {
  CPXController controller = CPXController.controller;
  WebViewController? _webController;
  bool isLoading = true;
  bool isAlertDisplayed = false;
  late CPXBrowserTab activeTab;

  /// [_loadURL] loads the url in the webview
  void _loadURL(CPXBrowserTab tab) {
    activeTab = tab;
    if (_webController != null) {
      _webController!.loadRequest(tab.url);
      CPXLogger.log("Load url: ${tab.url}");
    } else {
      CPXLogger.log(
          "Failed to load url: ${tab.url} | WebViewController is null");
    }
  }

  @override
  void initState() {
    activeTab = widget.currentTab;
    _initWebView();
    super.initState();
  }

  _initWebView() => _webController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (start) {
          if (mounted) setState(() => isLoading = true);
        },
        onPageFinished: (finish) {
          if (mounted) setState(() => isLoading = false);
        },
        onWebResourceError: (error) {
          HapticFeedback.selectionClick();
          if ((error.errorCode == -1 && Platform.isAndroid) ||
              (error.errorCode == -1022 && Platform.isIOS)) {
            setState(() => isAlertDisplayed = true);
          }
          CPXLogger.log(
              "Browser error: ${error.errorCode} | ${error.description}");
          CPXNetworkService().onWebViewError(error.errorCode.toString(),
              error.description, error.url ?? "no url");
        },
      ),
    )
    ..loadRequest(CPXBrowserTab.home.url);

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _BrowserNavigationButton(tab: CPXBrowserTab.help),
            const SizedBox(width: 2),
            _BrowserNavigationButton(tab: CPXBrowserTab.home),
            const SizedBox(width: 2),
            _BrowserNavigationButton(
              tab: CPXBrowserTab.close,
              onPressed: () {
                CPXLogger.log("Close CPX Browser");
                widget.onClose?.call() ??
                    CPXController.controller.showWidgets();
              },
            ),
          ],
        ),
        Expanded(
          child: ColoredBox(
            color: Colors.white,
            child: Stack(
              children: [
                WebViewWidget(controller: _webController!),
                if (isLoading)
                  LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                        controller.config.accentColor),
                    backgroundColor: Colors.white,
                  ),
                if (isAlertDisplayed) showReloadOnError(),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _BrowserNavigationButton({
    required CPXBrowserTab tab,
    Function()? onPressed,
    ButtonStyle? style,
  }) =>
      ElevatedButton(
          style: style ??
              ElevatedButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.symmetric(vertical: 12),
                overlayColor: controller.config.accentColor,
                backgroundColor: activeTab == tab
                    ? controller.config.accentColor
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
              ),
          onPressed: () {
            HapticFeedback.selectionClick();
            isAlertDisplayed = false;
            onPressed?.call() ?? _loadURL(tab);
          },
          child: Icon(
            tab.icon,
            color: Colors.black,
          ));

  Widget showReloadOnError() => Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _WebViewErrorButton(
              children: [
                Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                SizedBox(width: 4),
                Text("Go back", style: TextStyle(fontSize: 20)),
              ],
              onPressed: () => _webController!.goBack(),
            ),
            _WebViewErrorButton(
              children: [
                Icon(Icons.refresh, size: 20),
                SizedBox(width: 4),
                Text("Reload", style: TextStyle(fontSize: 20)),
              ],
              onPressed: () => _webController!.reload(),
            ),
            _WebViewErrorButton(
              children: [
                Text("Opinions", style: TextStyle(fontSize: 20)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios_rounded, size: 20),
              ],
              onPressed: () => _loadURL(CPXBrowserTab.home),
            ),
          ],
        ),
      );

  ElevatedButton _WebViewErrorButton({
    required List<Widget> children,
    required Function() onPressed,
  }) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: controller.config.accentColor,
          foregroundColor: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
        onPressed: () {
          HapticFeedback.selectionClick();
          setState(() => isAlertDisplayed = false);
          onPressed();
        },
      );
}
