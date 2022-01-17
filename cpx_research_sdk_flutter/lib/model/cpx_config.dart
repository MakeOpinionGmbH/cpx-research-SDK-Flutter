
import 'package:flutter/material.dart';

import 'cpx_style.dart';

/// With [CPXConfig] you can config the survey Widgets.
///
/// The [appID] is your app id
///
/// The [userID] is your external user id
///
/// The [singleSurvey] defines whether the webview is showing all or only a single survey
///
/// The [cornerWidget] defines the style of the corner widget. If you don't want to display the widget leave it out.
///
/// The [sidebarWidget] defines the style of the corner widget. If you don't want to display the widget leave it out.
///
/// The [notificationWidget] defines the style of the corner widget. If you don't want to display the widget leave it out.
///
class CPXConfig {
  final String appID;
  final String userID;
  final Color accentColor;
  final CPXStyle cornerWidget;
  final CPXStyle sidebarWidget;
  final CPXStyle notificationWidget;

  CPXConfig({
    @required this.appID,
    @required this.userID,
    this.accentColor,
    this.cornerWidget,
    this.sidebarWidget,
    this.notificationWidget,
  });
}
