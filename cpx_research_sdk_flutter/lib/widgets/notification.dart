import 'package:cpx_research_sdk_flutter/cpx_controller.dart';
import 'package:cpx_research_sdk_flutter/cpx_research.dart';
import 'package:cpx_research_sdk_flutter/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationWidget extends StatefulWidget {
  final CPXStyle style;

  NotificationWidget(this.style);

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  String position;
  Alignment getNotificationPosition() {
    switch (widget.style.position) {
      case WidgetPosition.ScreenCenterTop:
        position = "top";
        return Alignment.topCenter;
        break;
      default:
        position = "bottom";
        return Alignment.bottomCenter;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: Controller.controller.isCPXNotificationDisplayed,
      builder: (context, isCPXNotificationDisplayed, child) {
        if (isCPXNotificationDisplayed) {
          return Align(
            alignment: getNotificationPosition(),
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                Controller.controller.showBrowser(singleSurvey: widget.style.singleSurvey);
              },
              child: Container(
                width: widget.style.width,
                constraints: BoxConstraints(
                  minWidth: 1,
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                  minHeight: 1,
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(widget.style.roundedCorners),
                    bottomRight: Radius.circular(widget.style.roundedCorners),
                  ),
                  color: Colors.transparent,
                ),
                child: Stack(
                  children: [
                    Image(
                      image: NetworkImage(NetworkService().getCPXImage(type: "screen", position: position, style: widget.style).toString()),
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: IconButton(
                        alignment: Alignment.topRight,
                        icon: Icon(Icons.close),
                        color: widget.style.textColor,
                        iconSize: widget.style.textSize + 5,
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          // Controller.controller.showBrowser(currentTab: BrowserTab.settings, singleSurvey: widget.style.singleSurvey);
                          Controller.controller.hideNotification();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
