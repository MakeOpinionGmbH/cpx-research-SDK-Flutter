import 'package:cpx_research_sdk_flutter/cpx_controller.dart';
import 'package:cpx_research_sdk_flutter/utils/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/cpx_style.dart';

class Sidebar extends StatefulWidget {
  final CPXStyle style;

  Sidebar(this.style);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late String position;
  late BorderRadius radius;
  Alignment getSidePosition() {
    switch (widget.style.position) {
      case WidgetPosition.SideLeft:
        position = "left";
        radius = BorderRadius.only(topRight: Radius.circular(widget.style.roundedCorners), bottomRight: Radius.circular(widget.style.roundedCorners));
        return Alignment.centerLeft;
      default:
        position = "right";
        radius = BorderRadius.only(topLeft: Radius.circular(widget.style.roundedCorners), bottomLeft: Radius.circular(widget.style.roundedCorners));
        return Alignment.centerRight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: getSidePosition(),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Controller.controller.showBrowser(singleSurvey: widget.style.singleSurvey);
        },
        child: Image(
          image: NetworkImage(
            NetworkService().getCPXImage(type: "side", position: position, style: widget.style).toString(),
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
