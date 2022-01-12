
import 'package:flutter/material.dart';

/// With [CPXStyle] you can style the Survey Widgets.
///
/// The [position] defines where the widget is displayed.
///
/// The [text] is shown on the widget
///
/// You can adjust the [textSize], if the default is too small or big
///
/// The [backgroundColor] defines the background color of the widget
///
/// The [roundedCorners] defines the border radius of the widget
///
class CPXStyle {
  final double width;
  final double height;
  final WidgetPosition position;
  final bool singleSurvey;
  final String text;
  final double textSize;
  final Color textColor;
  final Color backgroundColor;
  final double roundedCorners;

  CPXStyle({
    this.width = 50,
    this.height = 200,
    this.position = WidgetPosition.SideRight,
    this.singleSurvey = false,
    this.text = "Survey",
    this.textSize = 10,
    this.textColor = Colors.white,
    this.backgroundColor = const Color(0xffFFAF20),
    this.roundedCorners = 10,
  });
}

/// The [WidgetPosition] enum defines the Position of the widgets
/// The notification widget is always horizontally centered at the top or bottom
/// The sidebar widget can be displayed left or right
/// The corner widget can be displayed left or right and at the top or bottom
enum WidgetPosition {
  SideLeft,
  SideRight,
  CornerTopLeft,
  CornerTopRight,
  CornerBottomRight,
  CornerBottomLeft,
  ScreenCenterTop,
  ScreenCenterBottom
}
