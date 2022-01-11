import 'package:cpx_research_sdk_flutter/cpx_controller.dart';
import 'package:cpx_research_sdk_flutter/cpx_research.dart';
import 'package:cpx_research_sdk_flutter/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Sidebar extends StatefulWidget {
  final CPXStyle style;

  Sidebar(this.style);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String position;
  BorderRadius radius;
  Alignment getSidePosition() {
    switch (widget.style.position) {
      case WidgetPosition.SideLeft:
        position = "left";
        radius = BorderRadius.only(topRight: Radius.circular(widget.style.roundedCorners), bottomRight: Radius.circular(widget.style.roundedCorners));
        return Alignment.centerLeft;
        break;
      default:
        position = "right";
        radius = BorderRadius.only(topLeft: Radius.circular(widget.style.roundedCorners), bottomLeft: Radius.circular(widget.style.roundedCorners));
        return Alignment.centerRight;
        break;
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
