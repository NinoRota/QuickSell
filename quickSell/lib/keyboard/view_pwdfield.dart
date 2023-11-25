import 'dart:math';
import 'package:flutter/material.dart';

class CustomPwdField extends StatelessWidget {
  final String data;

  const CustomPwdField(this.data);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PwdFieldPainter(data),
    );
  }
}

class PwdFieldPainter extends CustomPainter {
  final String data;

  PwdFieldPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final int pwdLength = data.length;

    final Paint pwdPaint = Paint()..color = Colors.black;
    final Paint rectPaint = Paint()..color = Color(0xff707070);

    final double per = size.width / 6;
    double offsetX = per;
    while (offsetX < size.width) {
      offsetX += per;
    }

    final double half = per / 2;
    final double radio = per / 8;

    pwdPaint.style = PaintingStyle.fill;

    if (data.isNotEmpty) {
      for (int i = 0; i < data.length && i < 6; i++) {
        canvas.drawArc(
          Rect.fromLTRB(
            i * per + half - radio,
            size.height / 2 - radio,
            i * per + half + radio,
            size.height / 2 + radio,
          ),
          0.0,
          2 * pi,
          true,
          pwdPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
