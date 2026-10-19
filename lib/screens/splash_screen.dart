import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../navigation.dart';
import '../theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/drawing_helpers.dart';
import 'home_screen.dart';

//  SCREEN 1 — SPLASH

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loading;

  @override
  void initState() {
    super.initState();
    _loading = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    _loading.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.of(context).pushReplacement(fadeTo(const HomeScreen()));
      }
    });
    _loading.forward();
  }

  @override
  void dispose() {
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SkyBackground(
      decor: _splashClouds,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 16),
                child: CustomPaint(
                  painter: _SplashArtPainter(),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            const StickerText(
              'Magic\nDrawing World',
              size: 40,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            const Label('Draw it. Bring it to life.', size: 18),
            const SizedBox(height: 48),
            AnimatedBuilder(
              animation: _loading,
              builder: (context, child) => _LoadingBar(progress: _loading.value),
            ),
            const SizedBox(height: 10),
            const Label('Getting crayons ready...', size: 14, color: Colors.white),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}

class _LoadingBar extends StatelessWidget {
  const _LoadingBar({required this.progress});

  final double progress; // 0.0 to 1.0

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: kNavy, width: 3),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: progress.clamp(0.0, 1.0).toDouble(),
          heightFactor: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: kPink,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

void _splashClouds(Canvas canvas, Size size) {
  drawCloud(canvas, size.width * 0.15, size.height * 0.13, size.width * 0.24);
  drawCloud(canvas, size.width * 0.82, size.height * 0.08, size.width * 0.22);
}

/// The paper, the purple fish, the crayon and the stars — all drawn in code.
class _SplashArtPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Everything is drawn on a 340 x 340 grid, then scaled to fit.
    const grid = 340.0;
    final s = math.min(size.width, size.height) / grid;
    canvas.save();
    canvas.translate(
      (size.width - grid * s) / 2,
      (size.height - grid * s) / 2,
    );
    canvas.scale(s);

    // Bubbles
    final bubble = paintStroke(Colors.white, 3);
    canvas.drawCircle(const Offset(53, 26), 5, bubble);
    canvas.drawCircle(const Offset(87, 13), 4, bubble);
    canvas.drawCircle(const Offset(73, 52), 8, bubble);

    // Paper with the dotted fish to trace
    drawRotated(canvas, -5, const Offset(170, 185), () {
      const corner = Radius.circular(22);
      canvas.drawRRect(
        RRect.fromRectAndRadius(const Rect.fromLTWH(30, 53, 280, 280), corner),
        paintFill(kNavy),
      );
      final paper =
      RRect.fromRectAndRadius(const Rect.fromLTWH(30, 45, 280, 280), corner);
      canvas.drawRRect(paper, paintFill(Colors.white));
      canvas.drawRRect(paper, paintStroke(kNavy, 5));
      canvas.drawPath(
        dashedPath(fishPath(95, 190, 150), 11, 9),
        paintStroke(const Color(0xFFC9BDF2), 4),
      );
    });

    // Little "jumping" lines by the tail
    canvas.drawArc(
      const Rect.fromLTWH(268, 2, 70, 70),
      -75 * math.pi / 180,
      60 * math.pi / 180,
      false,
      paintStroke(Colors.white, 4),
    );

    // Purple fish that came to life
    drawRotated(canvas, -10, const Offset(225, 75), () {
      final fish = fishPath(132, 75, 185);
      canvas.drawPath(fish, paintFill(kPurple));
      canvas.drawPath(fish, paintStroke(kNavy, 5));
      final shine = paintStroke(const Color(0xFFC9B3FF), 5);
      canvas.drawLine(const Offset(205, 50), const Offset(213, 92), shine);
      canvas.drawLine(const Offset(228, 54), const Offset(234, 88), shine);
      canvas.drawCircle(const Offset(160, 68), 8, paintFill(Colors.white));
      canvas.drawCircle(const Offset(160, 68), 8, paintStroke(kNavy, 3));
      canvas.drawCircle(const Offset(159, 68), 3.5, paintFill(kNavy));
    });

    // Crayon
    drawRotated(canvas, 38, const Offset(285, 300), () {
      final tip = Path()
        ..moveTo(273, 262)
        ..lineTo(285, 236)
        ..lineTo(297, 262)
        ..close();
      canvas.drawPath(tip, paintFill(kOrange));
      canvas.drawPath(tip, paintStroke(kNavy, 4));
      final body = RRect.fromRectAndRadius(
        const Rect.fromLTWH(273, 262, 24, 92),
        const Radius.circular(5),
      );
      canvas.drawRRect(body, paintFill(kYellow));
      canvas.drawRect(const Rect.fromLTWH(273, 276, 24, 12), paintFill(kOrangeDeep));
      canvas.drawRRect(body, paintStroke(kNavy, 4));
    });

    // Stars
    drawStar(canvas, 322, 140, 13);
    drawStar(canvas, 14, 318, 17);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}