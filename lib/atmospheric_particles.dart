import 'package:atmospheric_particles/particle_canvas.dart';
import 'package:flutter/material.dart';

/// A user-friendly wrapper widget that displays an animated [ParticleCanvas]
/// in the background and places a [child] widget on top of it.
///
/// This widget is the main public-facing widget for the package. It simplifies
/// the process of adding particle effects by managing the canvas size
/// and stacking.
class AtmosphericParticles extends StatelessWidget {
  /// Creates an [AtmosphericParticles] widget.
  ///
  /// The [child] widget is required and will be displayed on top of the
  /// particle animation. All other parameters are optional and provide
  /// customization for the particle effect.
  const AtmosphericParticles({
    required this.child,
    super.key,
    this.childAlignment = AlignmentGeometry.topCenter,
    this.height = double.infinity,
    this.enableVerticalFade = true,
    this.maxHorizontalVelocity = 30,
    this.minHorizontalVelocity = 10,
    this.maxVerticalVelocity = -20,
    this.minVerticalVelocity = -100,
    this.particleColor = Colors.deepPurple,
    this.particleCount = 200,
    this.particleRadius = 2,
    this.width = double.infinity,
  }) : assert(
          particleRadius > 0,
          'particleRadius must be bigger than 0',
        );

  /// How the [child] widget is aligned within the [Stack].
  /// Defaults to [AlignmentGeometry.topCenter].
  final AlignmentGeometry childAlignment;

  /// If true, particles will fade in (increase opacity) as they move
  /// down the canvas. Passed to [ParticleCanvas].
  final bool enableVerticalFade;

  /// The base color of the particles.
  final Color particleColor;

  /// The desired height of the particle canvas.
  /// Defaults to [double.infinity], which will fill the available vertical space.
  final double height;

  /// The maximum horizontal speed of particles (pixels per second).
  final double maxHorizontalVelocity;

  /// The maximum vertical speed of particles (pixels per second).
  /// Negative values move up.
  final double maxVerticalVelocity;

  /// The minimum horizontal speed of particles (pixels per second).
  /// Negative values move left.
  final double minHorizontalVelocity;

  /// The minimum vertical speed of particles (pixels per second).
  /// Negative values move up.
  final double minVerticalVelocity;

  /// The radius (size) of each particle. Must be greater than 0.
  final double particleRadius;

  /// The desired width of the particle canvas.
  /// Defaults to [double.infinity], which will fill the available horizontal space.
  final double width;

  /// The total number of particles to create and animate.
  final int particleCount;

  /// The widget to display in front of the particle animation.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to get the constraints (max width/height) from the parent.
    // This is essential for making `double.infinity` work correctly.
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use a Stack to overlay the child on top of the particle canvas.
        return Stack(
          alignment: childAlignment,
          children: [
            // The background layer (bottom of the stack)
            // ClipRRect ensures the particle canvas doesn't draw outside
            // its bounds, which can happen with particle wrapping.
            ClipRRect(
              child: ParticleCanvas(
                // If the user provided a finite width, use it.
                // Otherwise, use the maxWidth from the LayoutBuilder.
                width: width.isInfinite ? constraints.maxWidth : width,
                // If the user provided a finite height, use it.
                // Otherwise, use the maxHeight from the LayoutBuilder.
                height: height.isInfinite ? constraints.maxHeight : height,
                // Pass all the particle properties down to the canvas.
                color: particleColor,
                numberOfParticles: particleCount,
                enableVerticalFade: enableVerticalFade,
                particleRadius: particleRadius,
                minHorizontalVelocity: minHorizontalVelocity,
                maxHorizontalVelocity: maxHorizontalVelocity,
                minVerticalVelocity: minVerticalVelocity,
                maxVerticalVelocity: maxVerticalVelocity,
              ),
            ),
            // The foreground layer (top of the stack)
            child,
          ],
        );
      },
    );
  }
}
