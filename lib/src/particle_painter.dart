import 'package:flutter/material.dart';

import 'package:atmospheric_particles/src/fade_direction.dart';
import 'package:atmospheric_particles/src/particle.dart';

/// A [CustomPainter] responsible for drawing a list of [Particle] objects
/// onto a [Canvas].
class ParticlePainter extends CustomPainter {
  ParticlePainter({
    required this.particles,
    this.fadeDirection = FadeDirection.none,
    required this.color,
    required Listenable repaint,
  }) : super(repaint: repaint);

  final List<Particle> particles;
  final FadeDirection fadeDirection;
  final Color color;
  final Paint _paint = Paint()..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    if (particles.isEmpty) return;
    _paint.color = color;

    // Fast path: skip all opacity math if fading is disabled
    if (fadeDirection == FadeDirection.none) {
      for (final particle in particles) {
        canvas.drawCircle(
            Offset(particle.x, particle.y), particle.radius, _paint);
      }
      return;
    }

    // Hoist invariants and prepare for multiplication over division
    final double h = size.height == 0 ? 1.0 : size.height;
    final double w = size.width == 0 ? 1.0 : size.width;
    final double invH = 1.0 / h;
    final double invW = 1.0 / w;

    // Pre-compute base color components once to avoid per-particle work
    final int baseArgb = color.toARGB32();
    final int baseRgb = baseArgb & 0x00FFFFFF;
    final int baseAlpha = (baseArgb >> 24) & 0xFF;

    for (final particle in particles) {
      double fadeAlpha = switch (fadeDirection) {
        FadeDirection.top => particle.y * invH,
        FadeDirection.bottom => 1.0 - (particle.y * invH),
        FadeDirection.left => particle.x * invW,
        FadeDirection.right => 1.0 - (particle.x * invW),
        FadeDirection.none => 1.0,
      };

      // Inline manual clamp for performance in tight loop
      if (fadeAlpha < 0.0) {
        fadeAlpha = 0.0;
      } else if (fadeAlpha > 1.0) {
        fadeAlpha = 1.0;
      }

      // Multiply the color's own alpha by the fade alpha so that a semi-transparent
      // particleColor is respected rather than overwritten by the fade calculation.
      _paint.color = Color(((baseAlpha * fadeAlpha).round() << 24) | baseRgb);
      canvas.drawCircle(Offset(particle.x, particle.y), particle.radius, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => false;
}
