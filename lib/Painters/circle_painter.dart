import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CirclePainter extends CustomPainter {
  final Color primaryC;
  final Color secondaryC;
  final double deltaAngle;

  late double _bottomRadius;
  late double _topRadius;
  late double _sideRadius;

  CirclePainter(this.primaryC, this.secondaryC, this.deltaAngle);

  @override
  void paint(Canvas canvas, Size size) { // Fill the circle
    _topRadius = size.width/4 + 60;
    _bottomRadius = size.width/4 + 20;
    _sideRadius = size.width/4 + 30;    

    _drawSunExtension(canvas, 0 + deltaAngle, size);
    _drawSunExtension(canvas, pi/4 + deltaAngle, size);
    _drawSunExtension(canvas, pi/2 + deltaAngle, size);
    _drawSunExtension(canvas, 3*pi/4 + deltaAngle, size);
    _drawSunExtension(canvas, pi + deltaAngle, size);
    _drawSunExtension(canvas, 5*pi/4 + deltaAngle, size);
    _drawSunExtension(canvas, 3*pi/2 + deltaAngle, size);
    _drawSunExtension(canvas, 7*pi/4 + deltaAngle, size);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
  
  _drawSunExtension(Canvas canvas, double radians, Size size) {
    double x1 = _bottomRadius * cos(radians) + size.width/2;
    double y1 = _bottomRadius * sin(radians) + size.height/2;
    double x2 = _topRadius * cos(radians) + size.width/2;
    double y2 = _topRadius * sin(radians) + size.height/2;
    double x1d = _sideRadius * cos(radians + 0.25) + size.width/2;
    double y1d = _sideRadius * sin(radians + 0.25) + size.height/2;
    double x2d = _sideRadius * cos(radians - 0.25) + size.width/2;
    double y2d = _sideRadius * sin(radians - 0.25) + size.height/2;

    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(x1, _getY(y1, size.height)),
        Offset(x2, _getY(y2, size.height)),
        [
          secondaryC,
          primaryC,
        ],
      )
      ..style = PaintingStyle.fill; 
      

    final path = Path();
    path.moveTo(x1, _getY(y1, size.height));
    path.quadraticBezierTo(x2d, _getY(y2d, size.height), x2, _getY(y2, size.height));
    path.quadraticBezierTo(x1d, _getY(y1d, size.height), x1, _getY(y1, size.height));
    path.close();
    canvas.drawPoints(ui.PointMode.points, <Offset>[
      Offset(x1, y1),
      Offset(x2, y2)
    ], paint);
    canvas.drawPath(path, paint);
  }  

  double _getY(double p, double height) {
    return height - p;
  }
}