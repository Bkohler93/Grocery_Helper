import 'dart:math';
import 'package:flutter/material.dart';
import 'package:grocery_helper_app/data/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class NightToggle extends StatefulWidget {
  const NightToggle({Key? key, required this.setDark, required this.setLight}) : super(key: key);
  final Function setDark;
  final Function setLight;

  @override
  State<NightToggle> createState() => _NightToggleState();
}

class _NightToggleState extends State<NightToggle> {
  late double _startAngle;
  late bool switched;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    if (context.read<ThemeProvider>().isDarkMode) {
      _startAngle = pi / 2;
      switched = true;
    } else {
      _startAngle = 3 * pi / 2;
      switched = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NightToggleAnimation(
          startAngle: _startAngle,
          setDark: widget.setDark,
          setLight: widget.setLight,
        ),
        Switch(
          value: switched,
          onChanged: (value) {
            setState(
              () {
                switched = value;
                if (initialized) {
                  _startAngle = (_startAngle == (3 * pi / 2) ? (pi / 2) : (3 * pi / 2));
                } else {
                  initialized = true;
                }
              },
            );
          },
        ),
      ],
    );
  }
}

// * setLight
// sets Material App's theme mode to light

// * setDark
// sets material app's theme mode to dark
class NightToggleAnimation extends StatefulWidget {
  NightToggleAnimation(
      {Key? key, required this.startAngle, required this.setLight, required this.setDark})
      : super(key: key);
  double startAngle;
  Function setLight;
  Function setDark;

  @override
  State<NightToggleAnimation> createState() => _NightToggleAnimationState();
}

class _NightToggleAnimationState extends State<NightToggleAnimation>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void didUpdateWidget(covariant NightToggleAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.reset();

    Tween<double> _rotationTween = Tween(begin: widget.startAngle, end: widget.startAngle + pi);
    animation = _rotationTween.animate(controller)
      ..addListener(() {
        if (animation.value > 2 * pi) {
          widget.setDark();
        } else if (animation.value > pi && animation.value != (3 * pi / 2)) {
          widget.setLight();
        }

        setState(() {});
      })
      ..addStatusListener((status) {});
    controller.forward();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    Tween<double> _rotationTween = Tween(begin: widget.startAngle, end: widget.startAngle);

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      });

    controller.forward();
    controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: NightToggleAnimationPainter(angle: animation.value),
        child: Container(
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}

class NightToggleAnimationPainter extends CustomPainter {
  NightToggleAnimationPainter({required this.angle}) : super();
  final double angle;
  final double aspectDenom = 40;
  @override
  void paint(Canvas canvas, Size size) {
    var h = size.height;
    var w = size.width;
    var radius = calc(h, 15);

    var centerX = size.width / 2;
    var centerY = size.height;

    //sun
    var sunCenterY = centerY + sin(angle) * radius;
    var sunCenterX = centerX + cos(angle) * radius;
    var sunRadius = calc(h, 2.2);
    var sunCenter = Offset(sunCenterX, sunCenterY);
    //rays
    var rayLength = calc(h, 1);
    var rayDistance = calc(h, 2.2);

    //moon
    var moonCenterY = centerY - sin(angle) * radius;
    var moonCenterX = centerX - cos(angle) * radius;
    var moonRadius = sunRadius + rayLength;
    var moonStartX = moonCenterX + (moonRadius * 1 / 2);
    var moonStartY = moonCenterY + (moonRadius);
    var moonEndX = moonStartX;
    var moonEndY = moonCenterY - (moonRadius);

    var moonBrush = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0;

    var sunBrush = Paint()
      ..color = Color.fromARGB(255, 255, 235, 122)
      ..strokeWidth = 4.0;

    var horizonBrush = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2.0;

    canvas.drawLine(Offset(0.0, h), Offset(w, h), horizonBrush);

    //draw moon
    if (angle < pi || angle > 2 * pi) {
      final arc1 = Path()
        ..moveTo(moonStartX, moonStartY)
        ..arcToPoint(Offset(moonEndX, moonEndY), radius: Radius.circular(8.0))
        ..arcToPoint(Offset(moonStartX, moonStartY),
            radius: Radius.circular(20.0), clockwise: false);

      canvas.drawPath(arc1, moonBrush);
    }

    if (angle < 2 * pi && angle > pi) {
      canvas.drawCircle(sunCenter, sunRadius, sunBrush);

      if (angle < (2 * pi - 0.6)) {
        //bottom right ray
        canvas.drawLine(
            Offset(sunCenterX + rayDistance, sunCenterY + rayDistance),
            Offset(sunCenterX + rayDistance + rayLength, sunCenterY + rayDistance + rayLength),
            sunBrush);

        //bottom left ray
        canvas.drawLine(
            Offset(sunCenterX - rayDistance, sunCenterY + rayDistance),
            Offset(sunCenterX - (rayDistance + rayLength), sunCenterY + (rayDistance + rayLength)),
            sunBrush);

        // bottom middle ray
        canvas.drawLine(Offset(sunCenterX, sunCenterY + (2 * rayDistance)),
            Offset(sunCenterX, sunCenterY + (rayDistance + rayLength)), sunBrush);
      }

      //top left ray
      canvas.drawLine(
          Offset(sunCenterX - rayDistance, sunCenterY - rayDistance),
          Offset(sunCenterX - (rayDistance + rayLength), sunCenterY - (rayDistance + rayLength)),
          sunBrush);

      //top right ray
      canvas.drawLine(
          Offset(sunCenterX + rayDistance, sunCenterY - rayDistance),
          Offset(sunCenterX + (rayDistance + rayLength), sunCenterY - (rayDistance + rayLength)),
          sunBrush);

      //top middle ray
      canvas.drawLine(Offset(sunCenterX, sunCenterY - (2 * rayDistance)),
          Offset(sunCenterX, sunCenterY - (rayDistance + rayLength)), sunBrush);

      //right middle ray
      canvas.drawLine(Offset(sunCenterX + (rayDistance * 2), sunCenterY),
          Offset(sunCenterX + (rayDistance + rayLength), sunCenterY), sunBrush);

      //left middle ray
      canvas.drawLine(Offset(sunCenterX - (rayDistance * 2), sunCenterY),
          Offset(sunCenterX - (rayDistance + rayLength), sunCenterY), sunBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  double calc(double relativeSide, double relativeLength) {
    return relativeSide * relativeLength / aspectDenom;
  }
}
