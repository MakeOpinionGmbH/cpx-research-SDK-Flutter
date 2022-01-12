import 'package:cpx_research_sdk_flutter/cpx_controller.dart';
import 'package:cpx_research_sdk_flutter/utils/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/cpx_style.dart';

class Corner extends StatefulWidget {
  final CPXStyle style;

  Corner(this.style);

  @override
  _CornerState createState() => _CornerState();
}

class _CornerState extends State<Corner> {
  String position;
  int rotate = 1;
  Alignment getCornerPosition() {
    switch (widget.style.position) {
      case WidgetPosition.CornerBottomLeft:
        position = "bottomleft";
        rotate = 3;
        return Alignment.bottomLeft;
        break;
      case WidgetPosition.CornerTopLeft:
        position = "topleft";
        rotate = 0;
        return Alignment.topLeft;
        break;
      case WidgetPosition.CornerBottomRight:
        position = "bottomright";
        rotate = 2;
        return Alignment.bottomRight;
        break;
      default:
        position = "topright";
        rotate = 1;
        return Alignment.topRight;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: getCornerPosition(),
      child: RotatedBox(
        quarterTurns: rotate,
        child: CustomPaint(
          painter: _ClipShadowShadowPainter(
            clipper: CornerPath(widget.style.height, widget.style.width),
            shadow: Shadow(
              color: Colors.black54.withOpacity(0.2),
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ),
          child: ClipPath(
            clipper: CornerPath(widget.style.height, widget.style.width),
            child: GestureDetector(
              onTap: () => {
                HapticFeedback.selectionClick(),
                Controller.controller.showBrowser(singleSurvey: widget.style.singleSurvey),
              },
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(widget.style.roundedCorners)),
                ),
                child: RotatedBox(
                  quarterTurns: -rotate,
                  child: Image(
                    image: NetworkImage(NetworkService().getCPXImage(type: "corner", position: position.toString(), style: widget.style).toString()),
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
}

/// [CornerPath] draws the triangle inside of the corner widget
class CornerPath extends CustomClipper<Path> {
  final double x;
  final double y;

  CornerPath(this.x, this.y);

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, size.width)
      ..lineTo(0, y)
      ..lineTo(x, 0)
      ..lineTo(0, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

/// [_ClipShadowShadowPainter] draws the shadow behind the triangle inside of the corner widget
class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({@required this.shadow, @required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  /// The [hitTest] path defines the clickable area of the corner widget, without this function the shadow scope would overlay the screen and nothing below would be clickable
  @override
  bool hitTest(Offset position) {
    Path _path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, 100)
      ..lineTo(100, 0)
      ..lineTo(0, 0)
      ..close();
    return _path.contains(position);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
