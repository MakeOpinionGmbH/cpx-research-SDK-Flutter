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
        child: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.1,
            maxWidth: MediaQuery.of(context).size.width * 0.3,
            minHeight: MediaQuery.of(context).size.height * 0.1,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black54.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
            borderRadius: radius,
            color: Colors.transparent,
          ),
          child: Image(
            image: NetworkImage(
              NetworkService().getCPXImage(type: "side", position: position, style: widget.style).toString(),
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
