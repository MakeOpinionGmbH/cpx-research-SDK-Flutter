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
            if ((error.errorCode == -1 && Platform.isAndroid) ||
                (error.errorCode == -1022 && Platform.isIOS)) {
              setState(() => isAlertDisplayed = true);
            }
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
                      loadURL(1);
                      isAlertDisplayed = false;
                      activeTab = BrowserTab.help;
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
                      isAlertDisplayed = false;
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
                      isAlertDisplayed = false;
                      Controller.controller.showWidgets();
                    },
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ColoredBox(
                color: Colors.white,
                child: Stack(
                  children: [
                    WebViewWidget(controller: _controller!),
                    if (isLoading)
                      LinearProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(controller.config.accentColor),
                        backgroundColor: Colors.white,
                      ),
                    if (isAlertDisplayed) showReloadOnError(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showReloadOnError() => Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: controller.config.accentColor,
                foregroundColor: Colors.black,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  SizedBox(width: 4),
                  Text(
                    "Go back",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              onPressed: () {
                HapticFeedback.selectionClick();
                setState(() => isAlertDisplayed = false);
                _controller!.goBack();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: controller.config.accentColor,
                foregroundColor: Colors.black,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh, size: 20),
                  SizedBox(width: 4),
                  Text(
                    "Reload",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              onPressed: () {
                HapticFeedback.selectionClick();
                setState(() => isAlertDisplayed = false);
                _controller!.reload();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: controller.config.accentColor,
                foregroundColor: Colors.black,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Opinions",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios_rounded, size: 20),
                ],
              ),
              onPressed: () {
                HapticFeedback.selectionClick();
                setState(() => isAlertDisplayed = false);
                loadURL(0);
              },
            ),
          ],
        ),
      );
}
