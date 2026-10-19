import 'package:flutter/material.dart';

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