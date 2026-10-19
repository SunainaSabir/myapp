import 'package:flutter/material.dart';

import '../navigation.dart';
import '../theme.dart';
import '../widgets/common_widgets.dart';
import 'animal_screen.dart';

//  SCREEN 3 — WHAT WILL YOU DRAW?

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