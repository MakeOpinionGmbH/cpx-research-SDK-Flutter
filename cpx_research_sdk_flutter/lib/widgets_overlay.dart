import 'package:cpx_research_sdk_flutter/cpx_research.dart';
import 'package:cpx_research_sdk_flutter/widgets/corner.dart';
import 'package:cpx_research_sdk_flutter/widgets/notification.dart';
import 'package:cpx_research_sdk_flutter/widgets/sidebar.dart';
import 'package:flutter/material.dart';

class WidgetsOverlay extends StatefulWidget {
  final CPXStyle cornerWidget;
  final CPXStyle sidebarWidget;
  final CPXStyle notificationWidget;

  WidgetsOverlay(this.cornerWidget, this.sidebarWidget, this.notificationWidget);

  @override
  _WidgetsOverlayState createState() => _WidgetsOverlayState();
}

class _WidgetsOverlayState extends State<WidgetsOverlay> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          if (widget.cornerWidget != null) Corner(widget.cornerWidget),
          if (widget.sidebarWidget != null) Sidebar(widget.sidebarWidget),
          if (widget.notificationWidget != null) NotificationWidget(widget.notificationWidget)
        ],
      ),
    );
  }
}
