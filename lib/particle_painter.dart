import 'package:atmospheric_particles/particle.dart';
import 'package:flutter/material.dart';

/// A [CustomPainter] responsible for drawing a list of [Particle] objects
/// onto a [Canvas].
///
/// This painter can draw particles with a uniform color or with an alpha
/// (opacity) gradient based on their vertical position, creating a
/// "fade-in" effect from the top of the canvas.
class ParticlePainter extends CustomPainter {
  /// Creates a [ParticlePainter].
  ///
  /// [particles] is the list of particles to draw.
  /// [enableVerticalFade], if true, will make particles fade in (become more
  /// opaque) as they move down the canvas.
  ParticlePainter({required this.particles, this.enableVerticalFade = true});

  /// The list of [Particle] objects to be drawn.
  final List<Particle> particles;

  /// A flag to determine if particles should have a vertical opacity gradient.
  ///
  /// If `true`, particles at the top (lower `dy` value) will be more transparent,
  /// and particles at the bottom (higher `dy` value) will be more opaque.
  /// If `false`, all particles are drawn with their original color's opacity.
  final bool enableVerticalFade;

  /// A reusable [Paint] object to configure how circles are drawn.
  /// Its color is set dynamically within the `paint` method.
  final Paint _paint = Paint()..style = PaintingStyle.fill;

  /// Called by the Flutter framework to paint on the canvas.
  @override
  void paint(Canvas canvas, Size size) {
    // Check if the fade-in effect is enabled.
    if (enableVerticalFade) {
      // Loop through each particle to draw it individually.
      for (final particle in particles) {
        // Calculate the particle's normalized vertical position (0.0 to 1.0).
        // (0.0 is top, 1.0 is bottom).
        // A check for `size.height == 0` prevents division by zero.
        final normalizedHeight =
            particle.position.dy / (size.height == 0 ? 1 : size.height);

        // Calculate the alpha (opacity) value based on the normalized height.
        // `clamp` ensures the value is between 0.0 and 1.0.
        // We multiply by 255 to get a valid 8-bit alpha value.
        final alpha = (normalizedHeight.clamp(0.0, 1.0) * 255).toInt();

        // Set the paint's color using the particle's base color but with
        // the newly calculated alpha.
        _paint.color = particle.color.withAlpha(alpha);

        // Draw the particle as a circle on the canvas.
        canvas.drawCircle(particle.position, particle.radius, _paint);
      }
    } else {
      // Fade-in effect is disabled.
      // Assume all particles have the same color for efficiency and set it once.
      // This avoids setting the paint color inside the loop.
      _paint.color = particles[0].color;

      // Loop through each particle and draw it.
      for (final particle in particles) {
        canvas.drawCircle(
          particle.position,
          particle.radius,
          _paint,
        );
      }
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
