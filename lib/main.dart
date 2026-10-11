// Magic Drawing World — screens 1 to 4
// Put this file at:  lib/main.dart   (replace everything that is in there)

import 'dart:math' as math;

import 'package:flutter/material.dart';


//  COLORS + FONT//


const kSky = Color(0xFF3D9BF0);
const kNavy = Color(0xFF1F2F8C);
const kPink = Color(0xFFFF5C9D);
const kPinkSoft = Color(0xFFFFE3EE);
const kGreen = Color(0xFF5ED17A);
const kGreenDark = Color(0xFF3DB95E);
const kPurple = Color(0xFF9B6BFF);
const kOrange = Color(0xFFFFA726);
const kOrangeDeep = Color(0xFFFF8A3D);
const kYellow = Color(0xFFFFD23F);
const kIndigo = Color(0xFF2E3A9E);

// The design uses the rounded "Fredoka" font. After you add it to pubspec.yaml
// (see the note I sent with this file), change this line to:
//   const String? kFont = 'Fredoka';
const String? kFont = null;


//  APP//

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic Drawing World',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: kFont),
      home: const SplashScreen(),
    );
  }
}

/// Opens a new screen with a soft fade.
Route<void> fadeTo(Widget page) {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

/// Little message for buttons whose screens are not built yet.
void comingSoon(BuildContext context, String what) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('$what is coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
}

//  SCREEN 1 — SPLASH//

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
  _drawCloud(canvas, size.width * 0.15, size.height * 0.13, size.width * 0.24);
  _drawCloud(canvas, size.width * 0.82, size.height * 0.08, size.width * 0.22);
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
    final bubble = _stroke(Colors.white, 3);
    canvas.drawCircle(const Offset(53, 26), 5, bubble);
    canvas.drawCircle(const Offset(87, 13), 4, bubble);
    canvas.drawCircle(const Offset(73, 52), 8, bubble);

    // Paper with the dotted fish to trace
    _rotated(canvas, -5, const Offset(170, 185), () {
      const corner = Radius.circular(22);
      canvas.drawRRect(
        RRect.fromRectAndRadius(const Rect.fromLTWH(30, 53, 280, 280), corner),
        _fill(kNavy),
      );
      final paper =
      RRect.fromRectAndRadius(const Rect.fromLTWH(30, 45, 280, 280), corner);
      canvas.drawRRect(paper, _fill(Colors.white));
      canvas.drawRRect(paper, _stroke(kNavy, 5));
      canvas.drawPath(
        _dashed(_fishPath(95, 190, 150), 11, 9),
        _stroke(const Color(0xFFC9BDF2), 4),
      );
    });

    // Little "jumping" lines by the tail
    canvas.drawArc(
      const Rect.fromLTWH(268, 2, 70, 70),
      -75 * math.pi / 180,
      60 * math.pi / 180,
      false,
      _stroke(Colors.white, 4),
    );

    // Purple fish that came to life
    _rotated(canvas, -10, const Offset(225, 75), () {
      final fish = _fishPath(132, 75, 185);
      canvas.drawPath(fish, _fill(kPurple));
      canvas.drawPath(fish, _stroke(kNavy, 5));
      final shine = _stroke(const Color(0xFFC9B3FF), 5);
      canvas.drawLine(const Offset(205, 50), const Offset(213, 92), shine);
      canvas.drawLine(const Offset(228, 54), const Offset(234, 88), shine);
      canvas.drawCircle(const Offset(160, 68), 8, _fill(Colors.white));
      canvas.drawCircle(const Offset(160, 68), 8, _stroke(kNavy, 3));
      canvas.drawCircle(const Offset(159, 68), 3.5, _fill(kNavy));
    });

    // Crayon
    _rotated(canvas, 38, const Offset(285, 300), () {
      final tip = Path()
        ..moveTo(273, 262)
        ..lineTo(285, 236)
        ..lineTo(297, 262)
        ..close();
      canvas.drawPath(tip, _fill(kOrange));
      canvas.drawPath(tip, _stroke(kNavy, 4));
      final body = RRect.fromRectAndRadius(
        const Rect.fromLTWH(273, 262, 24, 92),
        const Radius.circular(5),
      );
      canvas.drawRRect(body, _fill(kYellow));
      canvas.drawRect(const Rect.fromLTWH(273, 276, 24, 12), _fill(kOrangeDeep));
      canvas.drawRRect(body, _stroke(kNavy, 4));
    });

    // Stars
    _drawStar(canvas, 322, 140, 13);
    _drawStar(canvas, 14, 318, 17);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


//  SCREEN 2 — HOME//

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SkyBackground(
      decor: _homeClouds,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Greeting + star counter
            const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StickerText('Hi, artist!', size: 28),
                      Label('What shall we do today?', size: 16),
                    ],
                  ),
                ),
                ChunkyCard(
                  radius: 50,
                  depth: 4,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Label('⭐ 12', size: 18, weight: FontWeight.w900),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 36),

            // The four big buttons
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: MenuCard(
                            emoji: '🎨',
                            label: 'Draw',
                            color: kPink,
                            tilt: -2,
                            onTap: () => Navigator.of(context)
                                .push(fadeTo(const CategoryScreen())),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: MenuCard(
                            emoji: '🌍',
                            label: 'My World',
                            color: kGreen,
                            tilt: 2,
                            onTap: () => comingSoon(context, 'My World'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: MenuCard(
                            emoji: '🧠',
                            label: 'Learn',
                            color: kPurple,
                            tilt: 1.5,
                            onTap: () => comingSoon(context, 'Learn'),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: MenuCard(
                            emoji: '⭐',
                            label: 'Challenge',
                            color: kOrange,
                            tilt: -1.5,
                            onTap: () => comingSoon(context, 'Challenge'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Sound + grown-ups buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundButton(
                  diameter: 56,
                  onTap: () => comingSoon(context, 'Sound'),
                  child: const Emoji('🔊', size: 24),
                ),
                RoundButton(
                  diameter: 56,
                  onTap: () => comingSoon(context, 'Parents area'),
                  child: const Emoji('👪', size: 24),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

void _homeClouds(Canvas canvas, Size size) {
  final cloud = Paint()..color = const Color(0xD9FFFFFF);
  canvas.drawOval(
    Rect.fromLTWH(
      size.width * 0.66,
      size.height * 0.16,
      size.width * 0.21,
      size.width * 0.07,
    ),
    cloud,
  );
  canvas.drawOval(
    Rect.fromLTWH(
      size.width * 0.06,
      size.height * 0.81,
      size.width * 0.19,
      size.width * 0.065,
    ),
    cloud,
  );
}

class MenuCard extends StatelessWidget {
  const MenuCard({
    super.key,
    required this.emoji,
    required this.label,
    required this.color,
    required this.tilt,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final Color color;
  final double tilt; // degrees
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: tilt * math.pi / 180,
      child: ChunkyCard(
        color: color,
        radius: 26,
        depth: 8,
        alignment: Alignment.center,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Emoji(emoji, size: 68),
                const SizedBox(height: 4),
                StickerText(label, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


//  SCREEN 3 — WHAT WILL YOU DRAW?//

class _Category {
  const _Category(this.emoji, this.name, this.color);

  final String emoji;
  final String name;
  final Color color;
}

const _categories = [
  _Category('🐶', 'Animal', kPink),
  _Category('🚗', 'Vehicle', kOrangeDeep),
  _Category('🦖', 'Creature', kPurple),
  _Category('🌳', 'Nature', kGreenDark),
  _Category('🚀', 'Space', kIndigo),
];

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SkyBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                RoundButton(
                  onTap: () => Navigator.of(context).pop(),
                  child: const StrokeIcon(StrokeIcon.back, color: kNavy),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: StickerText('What will you draw?', size: 22),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const HintPill('Tap a picture to choose!'),
            const SizedBox(height: 18),
            Expanded(
              child: ListView.separated(
                // bottom space keeps the last row above the grass
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return _CategoryRow(
                    category: category,
                    onTap: () {
                      if (category.name == 'Animal') {
                        Navigator.of(context).push(fadeTo(const AnimalScreen()));
                      } else {
                        comingSoon(context, category.name);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category, required this.onTap});

  final _Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ChunkyCard(
        color: category.color,
        radius: 24,
        depth: 7,
        alignment: Alignment.centerLeft,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0x40FFFFFF),
                  shape: BoxShape.circle,
                ),
                child: Emoji(category.emoji, size: 34),
              ),
              const SizedBox(width: 16),
              Expanded(child: StickerText(category.name, size: 24)),
              const StrokeIcon(StrokeIcon.forward, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}


//  SCREEN 4 — PICK YOUR ANIMAL//

class _Animal {
  const _Animal(this.emoji, this.name);

  final String emoji;
  final String name;
}

const _animals = [
  _Animal('🐠', 'Fish'),
  _Animal('🐶', 'Dog'),
  _Animal('🦋', 'Butterfly'),
  _Animal('🐱', 'Cat'),
];

class AnimalScreen extends StatefulWidget {
  const AnimalScreen({super.key});

  @override
  State<AnimalScreen> createState() => _AnimalScreenState();
}

class _AnimalScreenState extends State<AnimalScreen> {
  String _selected = 'Fish';

  Widget _card(_Animal animal) {
    return _AnimalCard(
      animal: animal,
      selected: _selected == animal.name,
      onTap: () => setState(() => _selected = animal.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SkyBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                RoundButton(
                  onTap: () => Navigator.of(context).pop(),
                  child: const StrokeIcon(StrokeIcon.back, color: kNavy),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: kPink,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: kNavy, width: 2),
                        ),
                        child: const Label(
                          '🐶 Animal',
                          size: 13,
                          color: Colors.white,
                          weight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const StickerText('Pick your animal', size: 22),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const HintPill('Which animal will you draw?'),
            const SizedBox(height: 10),

            // 2 x 2 grid of animals
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 10, bottom: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _card(_animals[0])),
                        const SizedBox(width: 18),
                        Expanded(child: _card(_animals[1])),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: _card(_animals[2])),
                        const SizedBox(width: 18),
                        Expanded(child: _card(_animals[3])),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Start button
            FractionallySizedBox(
              widthFactor: 0.78,
              child: SizedBox(
                height: 70,
                child: ChunkyCard(
                  color: kYellow,
                  radius: 35,
                  depth: 6,
                  alignment: Alignment.center,
                  // Next step: open the drawing screen (page 5) here.
                  onTap: () => comingSoon(context, 'Drawing your $_selected'),
                  child: const Label(
                    '✏️ Start drawing',
                    size: 22,
                    weight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 52),
          ],
        ),
      ),
    );
  }
}

class _AnimalCard extends StatelessWidget {
  const _AnimalCard({
    required this.animal,
    required this.selected,
    required this.onTap,
  });

  final _Animal animal;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ChunkyCard(
            color: selected ? kPinkSoft : Colors.white,
            borderColor: selected ? kPink : kNavy,
            shadowColor: selected ? kPink : kNavy,
            radius: 22,
            depth: 7,
            alignment: Alignment.center,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Emoji(animal.emoji, size: 60),
                    Label(animal.name, size: 22, weight: FontWeight.w900),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (selected)
          const Positioned(top: -6, right: 0, child: _CheckBadge()),
      ],
    );
  }
}

class _CheckBadge extends StatelessWidget {
  const _CheckBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kGreen,
        shape: BoxShape.circle,
        border: Border.all(color: kNavy, width: 3),
      ),
      child: const StrokeIcon(StrokeIcon.check, color: Colors.white, size: 13),
    );
  }
}


//  SHARED BUILDING BLOCKS (used by every screen)//

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
    canvas.drawPath(path, _stroke(color, size.width * 0.24));
  }

  @override
  bool shouldRepaint(covariant _StrokeIconPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}

// ── Drawing helpers ──────────────────────────────────────────────────────────

Paint _fill(Color color) => Paint()..color = color;

Paint _stroke(Color color, double width) {
  return Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
}

/// Runs [draw] with the canvas turned by [degrees] around [pivot].
void _rotated(Canvas canvas, double degrees, Offset pivot, VoidCallback draw) {
  canvas.save();
  canvas.translate(pivot.dx, pivot.dy);
  canvas.rotate(degrees * math.pi / 180);
  canvas.translate(-pivot.dx, -pivot.dy);
  draw();
  canvas.restore();
}

/// Cuts a path into dashes (Flutter has no built-in dotted line).
Path _dashed(Path source, double dash, double gap) {
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

void _drawCloud(Canvas canvas, double cx, double cy, double w) {
  final paint = _fill(Colors.white);
  final h = w * 0.36;
  canvas.drawOval(
    Rect.fromCenter(center: Offset(cx, cy), width: w, height: h),
    paint,
  );
  canvas.drawCircle(Offset(cx + w * 0.10, cy - h * 0.45), w * 0.20, paint);
  canvas.drawCircle(Offset(cx - w * 0.18, cy - h * 0.30), w * 0.14, paint);
}

void _drawStar(Canvas canvas, double cx, double cy, double radius) {
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
  canvas.drawPath(star, _fill(kYellow));
  canvas.drawPath(star, _stroke(kNavy, 3));
}

/// A simple fish facing left: nose at (left, cy), tail at left + len.
Path _fishPath(double left, double cy, double len) {
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