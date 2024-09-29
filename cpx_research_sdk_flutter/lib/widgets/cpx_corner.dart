/*
 * cpx_corner.dart
 * CPX Research
 *
 * Created by Dennis Kossmann on 18.7.2021.
 * Copyright © 2021. All rights reserved.
 */

import 'package:cpx_research_sdk_flutter/cpx_controller.dart';
import 'package:cpx_research_sdk_flutter/enumerations/cpx_widget_type.dart';
import 'package:cpx_research_sdk_flutter/model/cpx_style.dart';
import 'package:cpx_research_sdk_flutter/utils/cpx_network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CPXCorner extends StatelessWidget {
  final CPXStyle style;

  CPXCorner(this.style);

  @override
  Widget build(BuildContext context) => Align(
        alignment: style.position.alignment,
        child: RotatedBox(
          quarterTurns: style.position.rotate,
          child: CustomPaint(
            painter: _ClipShadowShadowPainter(
              clipper: _CornerPath(style.height, style.width),
              shadow: Shadow(
                color: Colors.black54.withOpacity(0.2),
                blurRadius: 3,
                offset: Offset(0, 3),
              ),
            ),
            child: ClipPath(
              clipper: _CornerPath(style.height, style.width),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  CPXController.controller
                      .showBrowser(singleSurvey: style.singleSurvey);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius:
                        BorderRadius.all(Radius.circular(style.roundedCorners)),
                  ),
                  child: RotatedBox(
                    quarterTurns: -style.position.rotate,
                    child: Image(
                      image: NetworkImage(CPXNetworkService()
                          .getCPXImage(
                              type: CPXWidgetType.corner,
                              position: style.position.key,
                              style: style)
                          .toString()),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

/// [_CornerPath] draws the triangle inside of the corner widget
class _CornerPath extends CustomClipper<Path> {
  final double x;
  final double y;

  _CornerPath(this.x, this.y);

  @override
  Path getClip(Size size) => Path()
    ..moveTo(0, size.width)
    ..lineTo(0, y)
    ..lineTo(x, 0)
    ..lineTo(0, 0)
    ..close();

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// [_ClipShadowShadowPainter] draws the shadow behind the triangle inside of the corner widget
class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  /// The [hitTest] path defines the clickable area of the corner widget, without this function the shadow scope would overlay the screen and nothing below would be clickable
  @override
  bool hitTest(Offset position) => (Path()
        ..moveTo(0, 0)
        ..lineTo(0, 100)
        ..lineTo(100, 0)
        ..lineTo(0, 0)
        ..close())
      .contains(position);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
