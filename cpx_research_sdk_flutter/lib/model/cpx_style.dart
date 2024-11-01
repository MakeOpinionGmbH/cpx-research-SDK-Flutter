/*
 * cpx_style.dart
 * CPX Research
 *
 * Created by Dennis Kossmann on 7.7.2021.
 * Copyright © 2021. All rights reserved.
 */

import 'package:cpx_research_sdk_flutter/enumerations/cpx_widget_position.dart';
import 'package:flutter/material.dart';

/// With [CPXStyle] you can style the Survey Widgets.
///
/// The [width] and [height] define the size of the widget
///
/// The [position] defines where the widget is displayed.
///
/// The [singleSurvey] defines if only one survey is displayed
///
/// The [text] is shown on the widget
///
/// You can adjust the [textSize], if the default is too small or big
///
/// The [textColor] defines the color of the text
///
/// The [backgroundColor] defines the background color of the widget
///
/// The [roundedCorners] defines the border radius of the widget
///
class CPXStyle {
  final double width;
  final double height;
  final CPXWidgetPosition position;
  final bool singleSurvey;
  final String text;
  final double textSize;
  final Color textColor;
  final Color backgroundColor;
  final double roundedCorners;

  CPXStyle({
    this.width = 50,
    this.height = 200,
    this.position = CPXWidgetPosition.SideRight,
    this.singleSurvey = false,
    this.text = "Survey",
    this.textSize = 10,
    this.textColor = Colors.white,
    this.backgroundColor = const Color(0xffFFAF20),
    this.roundedCorners = 10,
  });
}

