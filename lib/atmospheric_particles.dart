import 'package:flutter/widgets.dart';

import 'package:atmospheric_particles/src/fade_direction.dart';
import 'package:atmospheric_particles/src/particle_canvas.dart';

export 'src/fade_direction.dart';

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
    this.particleColor = _defaultParticleColor,
    this.particleCount = _defaultParticleCount,
    this.minParticleRadius = _defaultMinParticleRadius,
    this.maxParticleRadius = _defaultMaxParticleRadius,
    this.width = double.infinity,
    this.particlesInFront = false,
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
          particleCount >= 0,
          'particleCount must not be negative',
        );
  static const double _defaultMaxHorizontalVelocity = 30;
  static const double _defaultMinHorizontalVelocity = 10;
  static const double _defaultMaxVerticalVelocity = -20;
  static const double _defaultMinVerticalVelocity = -100;
  static const int _defaultParticleCount = 200;
  static const Color _defaultParticleColor = Color(0xFF673AB7); // deep purple
  static const double _defaultMinParticleRadius = 2;
  static const double _defaultMaxParticleRadius = 2;

  /// How the [child] widget is aligned within the [Stack].
  /// Defaults to [Alignment.topCenter].
  final AlignmentGeometry childAlignment;

  /// The direction of the fade effect for the particles.
  /// Defaults to [FadeDirection.none].
  final FadeDirection fadeDirection;

  /// The base color of the particles. Its alpha is respected, also when
  /// combined with [fadeDirection]. Defaults to deep purple (`0xFF673AB7`).
  final Color particleColor;

  /// The desired height of the particle canvas.
  /// Defaults to [double.infinity], which fills the available vertical space.
  /// If the parent gives unbounded height (e.g. inside a [Column] or a
  /// vertical scroll view), the canvas takes the height of [child] instead.
  final double height;

  /// The maximum horizontal speed of particles (pixels per second).
  /// Negative values move left.
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
  /// Defaults to [double.infinity], which fills the available horizontal space.
  /// If the parent gives unbounded width (e.g. inside a [Row]), the canvas
  /// takes the width of [child] instead.
  final double width;

  /// The total number of particles to create and animate. `0` shows no
  /// particles and stops the animation.
  final int particleCount;

  /// The widget to display in front of the particle animation.
  final Widget child;

  /// Whether the particles should be rendered in front of the child widget.
  /// Defaults to `false`, meaning particles are in the background.
  final bool particlesInFront;

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder resolves `double.infinity` to the space the parent offers.
    return LayoutBuilder(
      builder: (context, constraints) {
        final double? resolvedWidth = width.isFinite
            ? width
            : (constraints.hasBoundedWidth ? constraints.maxWidth : null);
        final double? resolvedHeight = height.isFinite
            ? height
            : (constraints.hasBoundedHeight ? constraints.maxHeight : null);

        ParticleCanvas canvas(double w, double h) => ParticleCanvas(
              width: w,
              height: h,
              color: particleColor,
              numberOfParticles: particleCount,
              fadeDirection: fadeDirection,
              minParticleRadius: minParticleRadius,
              maxParticleRadius: maxParticleRadius,
              minHorizontalVelocity: minHorizontalVelocity,
              maxHorizontalVelocity: maxHorizontalVelocity,
              minVerticalVelocity: minVerticalVelocity,
              maxVerticalVelocity: maxVerticalVelocity,
            );

        final Widget particleLayer;
        if (resolvedWidth != null && resolvedHeight != null) {
          particleLayer = ClipRect(
            child: canvas(resolvedWidth, resolvedHeight),
          );
        } else {
          // Unbounded in at least one axis: let the child decide the size and
          // stretch the particles over it.
          particleLayer = Positioned.fill(
            child: ClipRect(
              child: LayoutBuilder(
                builder: (context, c) => canvas(c.maxWidth, c.maxHeight),
              ),
            ),
          );
        }

        final stack = Stack(
          alignment: childAlignment,
          children: particlesInFront
              ? [child, particleLayer]
              : [particleLayer, child],
        );

        if (particleLayer is Positioned) {
          return SizedBox(
            width: resolvedWidth,
            height: resolvedHeight,
            child: stack,
          );
        }
        return stack;
      },
    );
  }
}
