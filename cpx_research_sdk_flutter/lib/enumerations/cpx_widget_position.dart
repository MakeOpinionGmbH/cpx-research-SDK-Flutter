/*
 * cpx_widget_position.dart
 * CPX Research
 *
 * Created by Dennis Kossmann on 29.9.2024.
 * Copyright © 2024. All rights reserved.
 */

import 'package:flutter/cupertino.dart';

/// The [CPXWidgetPosition] enum defines the position of the widgets
/// The notification widget is always horizontally centered at the top or bottom
/// The sidebar widget can be displayed left or right
/// The corner widget can be displayed left or right and at the top or bottom
enum CPXWidgetPosition {
  SideLeft,
  SideRight,
  CornerTopLeft,
  CornerTopRight,
  CornerBottomRight,
  CornerBottomLeft,
  ScreenCenterTop,
  ScreenCenterBottom;

  String get key {
    switch (this) {
      case CPXWidgetPosition.SideLeft:
        return "left";
      case CPXWidgetPosition.SideRight:
        return "right";
      case CPXWidgetPosition.CornerTopLeft:
        return "topleft";
      case CPXWidgetPosition.CornerTopRight:
        return "topright";
      case CPXWidgetPosition.CornerBottomRight:
        return "bottomright";
      case CPXWidgetPosition.CornerBottomLeft:
        return "bottomleft";
      case CPXWidgetPosition.ScreenCenterTop:
        return "top";
      case CPXWidgetPosition.ScreenCenterBottom:
        return "bottom";
    }
  }

  Alignment get alignment {
    switch (this) {
      case CPXWidgetPosition.SideLeft:
        return Alignment.centerLeft;
      case CPXWidgetPosition.SideRight:
        return Alignment.centerRight;
      case CPXWidgetPosition.CornerTopLeft:
        return Alignment.topLeft;
      case CPXWidgetPosition.CornerTopRight:
        return Alignment.topRight;
      case CPXWidgetPosition.CornerBottomRight:
        return Alignment.bottomRight;
      case CPXWidgetPosition.CornerBottomLeft:
        return Alignment.bottomLeft;
      case CPXWidgetPosition.ScreenCenterTop:
        return Alignment.topCenter;
      case CPXWidgetPosition.ScreenCenterBottom:
        return Alignment.bottomCenter;
    }
  }

  int get rotate {
    switch (this) {
      case CPXWidgetPosition.CornerTopLeft:
        return 0;
      case CPXWidgetPosition.CornerTopRight:
        return 1;
      case CPXWidgetPosition.CornerBottomRight:
        return 2;
      case CPXWidgetPosition.CornerBottomLeft:
        return 3;
      default:
        return 0;
    }
  }
}