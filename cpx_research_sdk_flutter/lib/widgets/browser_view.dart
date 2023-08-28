import 'dart:io';

import 'package:cpx_research_sdk_flutter/cpx_controller.dart';
import 'package:cpx_research_sdk_flutter/utils/cpx_logger.dart';
import 'package:cpx_research_sdk_flutter/utils/network_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum BrowserTab { home, settings, help }

class BrowserView extends StatefulWidget {
  final BrowserTab currentTab;

  BrowserView(this.currentTab);

  @override
  _BrowserViewState createState() => _BrowserViewState();
}

class _BrowserViewState extends State<BrowserView> {
  Controller controller = Controller.controller;
  bool isLoading = true;
  WebViewController? _controller;
  late List<Uri> pages;
  late BrowserTab activeTab;
  bool isAlertDisplayed = false;

  /// [loadURL] loads the url in the webview
  void loadURL(int index) {
    if (_controller != null) {
      _controller!.loadRequest(pages[index]);
      CPXLogger.log("Load url: ${pages[index]}");
    } else {
      CPXLogger.log("Failed to load url: ${pages[index]} | WebViewController is null");
    }
  }

  @override
  void initState() {
    activeTab = widget.currentTab;
    pages = [
      NetworkService().getHomeURL(),
      NetworkService().getSettingsURL(),
      NetworkService().getHelpURL(),
    ];
    initWebView();
    super.initState();
  }

  initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (start) => setState(() => isLoading = true),
          onPageFinished: (finish) => setState(() => isLoading = false),
          onWebResourceError: (error) {
            HapticFeedback.selectionClick();
            setState(() => isAlertDisplayed = true);
            CPXLogger.log(
                "Browser error: " + error.errorCode.toString() + " | " + error.description);
            NetworkService().onWebViewError(
                error.errorCode.toString(), error.description, error.url ?? "no url");
          },
        ),
      )
      ..loadRequest(pages[activeTab == BrowserTab.settings ? 1 : 0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: new BoxDecoration(
                    color:
                        activeTab == BrowserTab.help ? controller.config.accentColor : Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.help_outline),
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      loadURL(2);
                      activeTab = BrowserTab.help;
                    },
                    color: Colors.black,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: new BoxDecoration(
                    color: activeTab == BrowserTab.settings
                        ? controller.config.accentColor
                        : Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.settings_outlined),
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      loadURL(1);
                      activeTab = BrowserTab.settings;
                    },
                    color: Colors.black,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: new BoxDecoration(
                    color:
                        activeTab == BrowserTab.home ? controller.config.accentColor : Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.home_outlined),
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      loadURL(0);
                      activeTab = BrowserTab.home;
                    },
                    color: Colors.black,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      CPXLogger.log("Close CPX Browser");
                      Controller.controller.showWidgets();
                    },
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller!),
                  if (isLoading)
                    LinearProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(controller.config.accentColor),
                      backgroundColor: Colors.white,
                    ),
                  if (isAlertDisplayed) showErrorAlertDialog(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container showErrorAlertDialog() {
    Widget textButton = TextButton(
      child: Text(
        "OK",
        style: TextStyle(color: controller.config.accentColor),
      ),
      onPressed: () {
        HapticFeedback.selectionClick();
        setState(() => isAlertDisplayed = false);
        CPXLogger.log("Close CPX Browser");
        Controller.controller.showWidgets();
      },
    );
    return Container(
      color: Colors.black87,
      child: Platform.isIOS
          ? CupertinoAlertDialog(
              title: Text("Browser Error"),
              content: Text("An error occurred, while using the survey browser"),
              actions: [textButton],
            )
          : AlertDialog(
              title: Text("Browser Error"),
              content: Text("An error occurred, while using the survey browser"),
              actions: [textButton],
            ),
    );
  }
}
