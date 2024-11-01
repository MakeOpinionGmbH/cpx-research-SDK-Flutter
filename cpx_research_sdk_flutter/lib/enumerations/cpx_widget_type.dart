/*
 * cpx_widget_type.dart
 * CPX Research
 *
 * Created by Dennis Kossmann on 29.9.2024.
 * Copyright © 2024. All rights reserved.
 */

/// [CPXWidgetType] is an enumeration for the different types of cpx widgets
enum CPXWidgetType {
  side,
  corner,
  notification;

  String get key {
    switch (this) {
      case CPXWidgetType.side:
        return "side";
      case CPXWidgetType.corner:
        return "corner";
      case CPXWidgetType.notification:
        return "screen";
    }
  }
}