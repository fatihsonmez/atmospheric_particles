import 'package:flutter/material.dart';

import 'package:atmospheric_particles/src/fade_direction.dart';
import 'package:atmospheric_particles/src/particle.dart';

/// A [CustomPainter] responsible for drawing a list of [Particle] objects
/// onto a [Canvas].
///
/// This painter can draw particles with a uniform color or with an alpha
/// (opacity) gradient based on their position and a specified [FadeDirection].
class ParticlePainter extends CustomPainter {
  /// Creates a [ParticlePainter].
  ///
  /// [particles] is the list of particles to draw.
  /// [fadeDirection] determines the direction of the opacity gradient.
  ParticlePainter({
    required this.particles,
    this.fadeDirection = FadeDirection.none,
  });

  /// The list of [Particle] objects to be drawn.
  final List<Particle> particles;

  /// The direction of the fade effect.
  final FadeDirection fadeDirection;

  /// A reusable [Paint] object to configure how circles are drawn.
  /// Its color is set dynamically within the `paint` method.
  final Paint _paint = Paint()..style = PaintingStyle.fill;

  /// Called by the Flutter framework to paint on the canvas.
  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Draw the trail
      for (var i = 0; i < particle.history.length; i++) {
        final historicalPosition = particle.history[i];
        final opacity = (i / particle.history.length).clamp(0.0, 1.0);

        _paint.color = particle.color.withAlpha((opacity * 255).toInt());
        canvas.drawCircle(historicalPosition, particle.radius, _paint);
      }

      // Draw the current particle position with full opacity or fade effect
      if (fadeDirection == FadeDirection.none) {
        _paint.color = particle.color;
      } else {
        double normalizedValue;
        switch (fadeDirection) {
          case FadeDirection.top:
            normalizedValue =
                particle.position.dy / (size.height == 0 ? 1 : size.height);
            break;
          case FadeDirection.bottom:
            normalizedValue = 1.0 -
                (particle.position.dy / (size.height == 0 ? 1 : size.height));
            break;
          case FadeDirection.left:
            normalizedValue =
                particle.position.dx / (size.width == 0 ? 1 : size.width);
            break;
          case FadeDirection.right:
            normalizedValue = 1.0 -
                (particle.position.dx / (size.width == 0 ? 1 : size.width));
            break;
          case FadeDirection.none:
            normalizedValue = 1.0;
            break;
        }
        final alpha = (normalizedValue.clamp(0.0, 1.0) * 255).toInt();
        _paint.color = particle.color.withAlpha(alpha);
      }
      canvas.drawCircle(particle.position, particle.radius, _paint);
    }
  }

  /// Determines whether the painter should repaint.
  ///
  /// This is set to `true` because the particle positions are expected
  /// to change on every frame (due to the animation controller).
  /// Returning `true` ensures the canvas is redrawn for each new frame.
  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return true;
  }
}
