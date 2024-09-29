
/*
 * cpx_config.dart
 * CPX Research
 *
 * Created by Dennis Kossmann on 7.7.2021.
 * Copyright © 2021. All rights reserved.
 */

import 'package:flutter/material.dart';

import 'cpx_style.dart';

/// With [CPXConfig] you can config the survey Widgets.
///
/// The [appID] is your app id
///
/// The [userID] is your external user id
///
/// The [accentColor] is the color of the widgets
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
  final CPXStyle? cornerWidget;
  final CPXStyle? sidebarWidget;
  final CPXStyle? notificationWidget;

  CPXConfig({
    required this.appID,
    required this.userID,
    this.accentColor = const Color(0xffFFAF20),
    this.cornerWidget,
    this.sidebarWidget,
    this.notificationWidget,
  });
}
