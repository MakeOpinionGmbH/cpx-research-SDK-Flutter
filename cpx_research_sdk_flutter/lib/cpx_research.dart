/*
 * cpx_research.dart
 * CPX Research
 *
 * Created by Dennis Kossmann on 7.7.2021.
 * Copyright © 2021. All rights reserved.
 */

import 'dart:async';

import 'package:cpx_research_sdk_flutter/widgets/cpx_browser_view.dart';
import 'package:cpx_research_sdk_flutter/cpx_controller.dart';
import 'package:cpx_research_sdk_flutter/utils/cpx_logger.dart';
import 'package:cpx_research_sdk_flutter/utils/cpx_network_service.dart';
import 'package:flutter/material.dart';

import 'model/cpx_config.dart';
import 'widgets/cpx_corner.dart';
import 'widgets/cpx_notification.dart';
import 'widgets/cpx_sidebar.dart';

class CPXResearch extends StatefulWidget {
  final CPXConfig config;

  CPXResearch({required this.config});

  @override
  _CPXResearchState createState() => _CPXResearchState();
}

class _CPXResearchState extends State<CPXResearch> with WidgetsBindingObserver {
  late Timer _timer;

  /// The function [_startTimer] starts the automatic survey check every 120 seconds
  void _startTimer() {
    _timer = Timer.periodic(
      Duration(seconds: 120),
      (Timer t) {
        CPXNetworkService().fetchSurveysAndTransactions();
        CPXController.controller.showNotification();
      },
    );
    CPXLogger.log("Timer for automatic survey check started");
    CPXNetworkService().fetchSurveysAndTransactions();
  }

  /// The function [_stopTimer] stops the automatic survey check
  void _stopTimer() {
    _timer.cancel();
    CPXLogger.log("Timer for automatic survey check stopped");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    CPXController.controller.config = widget.config;
    _startTimer();
  }

  /// The function [didChangeAppLifecycleState] listens to app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _startTimer();
      case AppLifecycleState.inactive:
        _stopTimer();
      default:
        return;
    }
  }

  @override
  void dispose() {
    _stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
        valueListenable: CPXController.controller.isCPXResearchLayerDisplayed,
        builder: (context, isCPXResearchLayerDisplayed, _) =>
            isCPXResearchLayerDisplayed
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ValueListenableBuilder<bool>(
                      valueListenable:
                          CPXController.controller.areCPXWidgetsDisplayed,
                      builder: (context, areCPXWidgetsDisplayed, _) =>
                          areCPXWidgetsDisplayed
                              ? SafeArea(
                                  child: Stack(
                                    children: [
                                      if (widget.config.cornerWidget != null)
                                        CPXCorner(widget.config.cornerWidget!),
                                      if (widget.config.sidebarWidget != null)
                                        CPXSidebar(
                                            widget.config.sidebarWidget!),
                                      if (widget.config.notificationWidget !=
                                          null)
                                        CPXNotification(
                                            widget.config.notificationWidget!)
                                    ],
                                  ),
                                )
                              : CPXBrowserView(
                                  CPXController.controller.activeTab),
                    ),
                  )
                : const SizedBox(),
      );
}
