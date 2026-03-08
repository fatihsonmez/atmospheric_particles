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

    for (final particle in particles) {
      final pos = Offset(particle.x, particle.y);

      double alpha = switch (fadeDirection) {
        FadeDirection.top => pos.dy * invH,
        FadeDirection.bottom => 1.0 - (pos.dy * invH),
        FadeDirection.left => pos.dx * invW,
        FadeDirection.right => 1.0 - (pos.dx * invW),
        FadeDirection.none => 1.0,
      };

      // Inline manual clamp for performance in tight loop
      if (alpha < 0.0) {
        alpha = 0.0;
      } else if (alpha > 1.0) {
        alpha = 1.0;
      }

      _paint.color = color.withValues(alpha: alpha);
      canvas.drawCircle(pos, particle.radius, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => false;
}
