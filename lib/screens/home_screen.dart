import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../navigation.dart';
import '../theme.dart';
import '../widgets/common_widgets.dart';
import 'category_screen.dart';

//  SCREEN 2 — HOME

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