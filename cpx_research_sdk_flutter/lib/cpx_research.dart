import 'dart:async';

import 'package:cpx_research_sdk_flutter/widgets/browser_view.dart';
import 'package:cpx_research_sdk_flutter/cpx_controller.dart';
import 'package:cpx_research_sdk_flutter/utils/cpx_logger.dart';
import 'package:cpx_research_sdk_flutter/utils/network_service.dart';
import 'package:flutter/material.dart';

import 'model/cpx_config.dart';
import 'widgets/corner.dart';
import 'widgets/notification.dart';
import 'widgets/sidebar.dart';

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
      (Timer t) => {
        NetworkService().fetchSurveysAndTransactions(),
        Controller.controller.showNotification(),
      },
    );
    CPXLogger.log("Timer for automatic survey check started");
    NetworkService().fetchSurveysAndTransactions();
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
    Controller.controller.config = widget.config;
    _startTimer();
  }

  /// The function [didChangeAppLifecycleState] listens to app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _startTimer();
        break;
      case AppLifecycleState.inactive:
        _stopTimer();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: Controller.controller.isCPXResearchLayerDisplayed,
      builder: (context, isCPXResearchLayerDisplayed, _) {
        if (isCPXResearchLayerDisplayed) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ValueListenableBuilder<bool>(
              valueListenable: Controller.controller.areCPXWidgetsDisplayed,
              builder: (context, areCPXWidgetsDisplayed, _) {
                if (areCPXWidgetsDisplayed) {
                  return SafeArea(
                    child: Stack(
                      children: [
                        if (widget.config.cornerWidget != null) Corner(widget.config.cornerWidget!),
                        if (widget.config.sidebarWidget != null) Sidebar(widget.config.sidebarWidget!),
                        if (widget.config.notificationWidget != null) NotificationWidget(widget.config.notificationWidget!)
                      ],
                    ),
                  );
                } else {
                  return BrowserView(Controller.controller.activeTab);
                }
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
