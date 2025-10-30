export 'src/fade_direction.dart';
import 'package:flutter/material.dart';

import 'package:atmospheric_particles/src/fade_direction.dart';
import 'package:atmospheric_particles/src/particle_canvas.dart';

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
    this.childAlignment = Alignment.topCenter,
    this.height = double.infinity,
    this.fadeDirection = FadeDirection.none,
    this.maxHorizontalVelocity = _defaultMaxHorizontalVelocity,
    this.minHorizontalVelocity = _defaultMinHorizontalVelocity,
    this.maxVerticalVelocity = _defaultMaxVerticalVelocity,
    this.minVerticalVelocity = _defaultMinVerticalVelocity,
    this.particleColor = Colors.deepPurple,
    this.particleCount = _defaultParticleCount,
    this.minParticleRadius = _defaultMinParticleRadius,
    this.maxParticleRadius = _defaultMaxParticleRadius,
    this.width = double.infinity,
    this.particlesInFront = false,
    this.trailLength = _defaultTrailLength,
  })  : assert(
          minParticleRadius > 0,
          'minParticleRadius must be bigger than 0',
        ),
        assert(
          minHorizontalVelocity <= maxHorizontalVelocity,
          'minHorizontalVelocity must be less than or equal to maxHorizontalVelocity',
        ),
        assert(
          minVerticalVelocity <= maxVerticalVelocity,
          'minVerticalVelocity must be less than or equal to maxVerticalVelocity',
        ),
        assert(
          minParticleRadius <= maxParticleRadius,
          'minParticleRadius must be less than or equal to maxParticleRadius',
        ),
        assert(
          particleCount > 0,
          'particleCount must be bigger than 0',
        );
  static const double _defaultMaxHorizontalVelocity = 30;
  static const double _defaultMinHorizontalVelocity = 10;
  static const double _defaultMaxVerticalVelocity = -20;
  static const double _defaultMinVerticalVelocity = -100;
  static const int _defaultParticleCount = 200;
  static const double _defaultMinParticleRadius = 2;
  static const double _defaultMaxParticleRadius = 2;
  static const int _defaultTrailLength = 0;

  /// How the [child] widget is aligned within the [Stack].
  /// Defaults to [Alignment.topCenter].
  final AlignmentGeometry childAlignment;

  /// The direction of the fade effect for the particles.
  /// Defaults to [FadeDirection.none].
  final FadeDirection fadeDirection;

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

  /// The minimum radius (size) of each particle. Must be greater than 0.
  final double minParticleRadius;

  /// The maximum radius (size) of each particle. Must be greater than 0.
  final double maxParticleRadius;

  /// The desired width of the particle canvas.
  /// Defaults to [double.infinity], which will fill the available horizontal space.
  final double width;

  /// The total number of particles to create and animate.
  final int particleCount;

  /// The widget to display in front of the particle animation.
  final Widget child;

  /// Whether the particles should be rendered in front of the child widget.
  /// Defaults to `false`, meaning particles are in the background.
  final bool particlesInFront;

  /// The length of the particle trails. A value of 0 means no trail.
  final int trailLength;

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to get the constraints (max width/height) from the parent.
    // This is essential for making `double.infinity` work correctly.
    return LayoutBuilder(
      builder: (context, constraints) {
        final particleCanvas = ClipRRect(
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
            fadeDirection: fadeDirection,
            minParticleRadius: minParticleRadius,
            maxParticleRadius: maxParticleRadius,
            minHorizontalVelocity: minHorizontalVelocity,
            maxHorizontalVelocity: maxHorizontalVelocity,
            minVerticalVelocity: minVerticalVelocity,
            maxVerticalVelocity: maxVerticalVelocity,
            trailLength: trailLength,
          ),
        );

        return Stack(
          alignment: childAlignment,
          children: particlesInFront
              ? [child, particleCanvas]
              : [particleCanvas, child],
        );
      },
    );
  }
}
