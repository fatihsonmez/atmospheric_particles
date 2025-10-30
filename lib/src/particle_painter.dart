import 'package:flutter/material.dart';

import 'package:atmospheric_particles/src/fade_direction.dart';
import 'package:atmospheric_particles/src/particle.dart';
import 'package:atmospheric_particles/src/particle_shape.dart';

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

  double _getFadeAlphaForPosition(Offset position, Size size) {
    if (fadeDirection == FadeDirection.none) {
      return 1.0;
    }

    double normalizedValue;
    switch (fadeDirection) {
      case FadeDirection.top:
        normalizedValue = position.dy / (size.height == 0 ? 1 : size.height);
        break;
      case FadeDirection.bottom:
        normalizedValue = 1.0 - (position.dy / (size.height == 0 ? 1 : size.height));
        break;
      case FadeDirection.left:
        normalizedValue = position.dx / (size.width == 0 ? 1 : size.width);
        break;
      case FadeDirection.right:
        normalizedValue = 1.0 - (position.dx / (size.width == 0 ? 1 : size.width));
        break;
      case FadeDirection.none:
        normalizedValue = 1.0;
        break;
    }
    return normalizedValue.clamp(0.0, 1.0);
  }

  /// Called by the Flutter framework to paint on the canvas.
  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Draw the trail
      for (var i = 0; i < particle.history.length; i++) {
        final historicalPosition = particle.history[i];
        final trailOpacity = (i / particle.history.length).clamp(0.0, 1.0);
        final fadeAlpha = _getFadeAlphaForPosition(historicalPosition, size);
        final finalOpacity = trailOpacity * fadeAlpha;

        _paint.color = particle.color.withAlpha((finalOpacity * 255).toInt());
        _drawShape(canvas, historicalPosition, particle.radius,
            particle.shape ?? ParticleShape.circle);
      }

      // Draw the current particle position
      final fadeAlpha = _getFadeAlphaForPosition(particle.position, size);
      _paint.color = particle.color.withAlpha((fadeAlpha * 255).toInt());
      _drawShape(canvas, particle.position, particle.radius,
          particle.shape ?? ParticleShape.circle);
    }
  }

  void _drawShape(
    Canvas canvas,
    Offset position,
    double radius,
    ParticleShape shape,
  ) {
    switch (shape) {
      case ParticleShape.circle:
        canvas.drawCircle(position, radius, _paint);
        break;
      case ParticleShape.square:
        canvas.drawRect(
          Rect.fromCircle(center: position, radius: radius),
          _paint,
        );
        break;
      case ParticleShape.triangle:
        final path = Path();
        path.moveTo(position.dx, position.dy - radius);
        path.lineTo(position.dx + radius, position.dy + radius);
        path.lineTo(position.dx - radius, position.dy + radius);
        path.close();
        canvas.drawPath(path, _paint);
        break;
      case ParticleShape.oval:
        canvas.drawOval(
          Rect.fromCircle(center: position, radius: radius),
          _paint,
        );
        break;
      case ParticleShape.rrect:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCircle(center: position, radius: radius),
            Radius.circular(radius / 4),
          ),
          _paint,
        );
        break;
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
