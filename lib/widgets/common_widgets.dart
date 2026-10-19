import 'package:flutter/material.dart';

import '../theme.dart';
import 'drawing_helpers.dart';

//  SHARED BUILDING BLOCKS (used by every screen)

typedef SkyDecor = void Function(Canvas canvas, Size size);

/// Blue sky with green hills at the bottom. `decor` lets a screen add clouds.
class SkyBackground extends StatelessWidget {
  const SkyBackground({super.key, required this.child, this.decor});

  final Widget child;
  final SkyDecor? decor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSky,
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _SkyPainter(decor))),
          Positioned.fill(child: SafeArea(child: child)),
        ],
      ),
    );
  }
}

class _SkyPainter extends CustomPainter {
  const _SkyPainter(this.decor);

  final SkyDecor? decor;

  @override
  void paint(Canvas canvas, Size size) {
    decor?.call(canvas, size);
    final w = size.width;
    final h = size.height;
    final back = Paint()..color = kGreen;
    canvas.drawOval(Rect.fromLTWH(-w * 0.25, h - w * 0.19, w * 0.95, w * 0.5), back);
    canvas.drawOval(Rect.fromLTWH(w * 0.40, h - w * 0.17, w * 0.95, w * 0.5), back);
    canvas.drawOval(
      Rect.fromLTWH(-w * 0.20, h - w * 0.10, w * 1.4, w * 0.4),
      Paint()..color = kGreenDark,
    );
  }

  @override
  bool shouldRepaint(covariant _SkyPainter oldDelegate) => false;
}

/// The "sticker" look: coloured box, thick outline and a solid shadow below.
///
/// Leave [alignment] empty when the card should hug its child (small pills).
/// Set it (for example Alignment.center) when the card has a fixed size.
class ChunkyCard extends StatelessWidget {
  const ChunkyCard({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.borderColor = kNavy,
    this.shadowColor = kNavy,
    this.radius = 24,
    this.depth = 6,
    this.alignment,
    this.onTap,
  });

  final Widget child;
  final Color color;
  final Color borderColor;
  final Color shadowColor;
  final double radius;
  final double depth;
  final AlignmentGeometry? alignment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final corners = BorderRadius.circular(radius);
    final align = alignment;
    final content = align == null ? child : Align(alignment: align, child: child);

    return Padding(
      padding: EdgeInsets.only(bottom: depth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: corners,
          boxShadow: [BoxShadow(color: shadowColor, offset: Offset(0, depth))],
        ),
        child: Material(
          color: color,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: corners,
            side: BorderSide(color: borderColor, width: 3),
          ),
          child: InkWell(onTap: onTap, child: content),
        ),
      ),
    );
  }
}

/// White round button (back, sound, parents).
class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    required this.onTap,
    required this.child,
    this.diameter = 48,
  });

  final VoidCallback onTap;
  final Widget child;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return ChunkyCard(
      radius: diameter / 2,
      depth: 5,
      onTap: onTap,
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: Center(child: child),
      ),
    );
  }
}

/// White speech bar under the title, e.g. "🔊 Tap a picture to choose!"
class HintPill extends StatelessWidget {
  const HintPill(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ChunkyCard(
        radius: 18,
        depth: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Label('🔊 $text', size: 17),
        ),
      ),
    );
  }
}

/// Big white heading with a hard navy shadow.
class StickerText extends StatelessWidget {
  const StickerText(
      this.text, {
        super.key,
        required this.size,
        this.color = Colors.white,
        this.textAlign,
      });

  final String text;
  final double size;
  final Color color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: size,
        height: 1.15,
        fontWeight: FontWeight.w900,
        color: color,
        shadows: [Shadow(color: kNavy, offset: Offset(0, size / 9))],
      ),
    );
  }
}

/// Plain text in the app font.
class Label extends StatelessWidget {
  const Label(
      this.text, {
        super.key,
        required this.size,
        this.color = kNavy,
        this.weight = FontWeight.w700,
      });

  final String text;
  final double size;
  final Color color;
  final FontWeight weight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        height: 1.25,
        fontWeight: weight,
        color: color,
      ),
    );
  }
}

/// An emoji used as a picture.
class Emoji extends StatelessWidget {
  const Emoji(this.emoji, {super.key, required this.size});

  final String emoji;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(emoji, style: TextStyle(fontSize: size, height: 1.2));
  }
}

/// Small thick line icons: back arrow, forward arrow and tick.
class StrokeIcon extends StatelessWidget {
  const StrokeIcon(this.points, {super.key, required this.color, this.size = 14});

  // Points are fractions of the icon size (0 = left/top, 1 = right/bottom).
  static const back = [Offset(0.68, 0.12), Offset(0.28, 0.5), Offset(0.68, 0.88)];
  static const forward = [Offset(0.32, 0.12), Offset(0.72, 0.5), Offset(0.32, 0.88)];
  static const check = [Offset(0.14, 0.55), Offset(0.40, 0.80), Offset(0.88, 0.24)];

  final List<Offset> points;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _StrokeIconPainter(points, color),
    );
  }
}

class _StrokeIconPainter extends CustomPainter {
  const _StrokeIconPainter(this.points, this.color);

  final List<Offset> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(points.first.dx * size.width, points.first.dy * size.height);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx * size.width, point.dy * size.height);
    }
    canvas.drawPath(path, paintStroke(color, size.width * 0.24));
  }

  @override
  bool shouldRepaint(covariant _StrokeIconPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}