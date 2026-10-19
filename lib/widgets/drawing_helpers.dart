import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

// ── Drawing helpers

Paint paintFill(Color color) => Paint()..color = color;

Paint paintStroke(Color color, double width) {
  return Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
}

/// Runs [draw] with the canvas turned by [degrees] around [pivot].
void drawRotated(Canvas canvas, double degrees, Offset pivot, VoidCallback draw) {
  canvas.save();
  canvas.translate(pivot.dx, pivot.dy);
  canvas.rotate(degrees * math.pi / 180);
  canvas.translate(-pivot.dx, -pivot.dy);
  draw();
  canvas.restore();
}

/// Cuts a path into dashes (Flutter has no built-in dotted line).
Path dashedPath(Path source, double dash, double gap) {
  final result = Path();
  for (final metric in source.computeMetrics()) {
    double distance = 0;
    while (distance < metric.length) {
      final end = math.min(distance + dash, metric.length);
      result.addPath(metric.extractPath(distance, end), Offset.zero);
      distance += dash + gap;
    }
  }
  return result;
}

void drawCloud(Canvas canvas, double cx, double cy, double w) {
  final paint = paintFill(Colors.white);
  final h = w * 0.36;
  canvas.drawOval(
    Rect.fromCenter(center: Offset(cx, cy), width: w, height: h),
    paint,
  );
  canvas.drawCircle(Offset(cx + w * 0.10, cy - h * 0.45), w * 0.20, paint);
  canvas.drawCircle(Offset(cx - w * 0.18, cy - h * 0.30), w * 0.14, paint);
}

void drawStar(Canvas canvas, double cx, double cy, double radius) {
  final star = Path();
  for (var i = 0; i < 10; i++) {
    final r = i.isEven ? radius : radius * 0.5;
    final angle = (-90 + i * 36) * math.pi / 180;
    final x = cx + r * math.cos(angle);
    final y = cy + r * math.sin(angle);
    if (i == 0) {
      star.moveTo(x, y);
    } else {
      star.lineTo(x, y);
    }
  }
  star.close();
  canvas.drawPath(star, paintFill(kYellow));
  canvas.drawPath(star, paintStroke(kNavy, 3));
}

/// A simple fish facing left: nose at (left, cy), tail at left + len.
Path fishPath(double left, double cy, double len) {
  final h = len * 0.26;
  final bodyEnd = left + len * 0.72;
  return Path()
    ..moveTo(left, cy)
    ..cubicTo(left + len * 0.15, cy - h * 1.4, left + len * 0.50, cy - h * 1.4,
        bodyEnd, cy - h * 0.2)
    ..lineTo(left + len, cy - h)
    ..lineTo(left + len * 0.92, cy)
    ..lineTo(left + len, cy + h)
    ..lineTo(bodyEnd, cy + h * 0.2)
    ..cubicTo(left + len * 0.50, cy + h * 1.4, left + len * 0.15, cy + h * 1.4,
        left, cy)
    ..close();
}