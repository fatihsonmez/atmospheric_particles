import 'dart:math';

import 'package:atmospheric_particles/fade_direction.dart';
import 'package:atmospheric_particles/particle.dart';
import 'package:atmospheric_particles/particle_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Import for Ticker

/// A [StatefulWidget] that renders an animated canvas of moving particles.
///
/// This widget manages the state of all particles, including their creation,
/// animation, and boundary handling (wrapping around the edges).
class ParticleCanvas extends StatefulWidget {
  const ParticleCanvas({
    required this.height,
    required this.width,
    required this.color,
    required this.fadeDirection,
    required this.minHorizontalVelocity,
    required this.maxHorizontalVelocity,
    required this.minVerticalVelocity,
    required this.maxVerticalVelocity,
    super.key,
    required this.numberOfParticles,
    required this.particleRadius,
  })  : // Use assertions in the initializer list to validate inputs
        assert(
          minHorizontalVelocity <= maxHorizontalVelocity,
          'minHorizontalVelocity must be less or equal to maxHorizontalVelocity',
        ),
        assert(
          minVerticalVelocity <= maxVerticalVelocity,
          'minVerticalVelocity must be less or equal to maxVerticalVelocity',
        );

  // --- Widget Properties ---

  /// The height of the canvas.
  final double height;

  /// The width of the canvas.
  final double width;

  /// The base color for all particles.
  final Color color;

  /// The total number of particles to create and animate.
  final int numberOfParticles;

  /// The direction of the fade effect.
  final FadeDirection fadeDirection;

  /// The radius (size) of each particle.
  final double particleRadius;

  /// The minimum horizontal speed (pixels per second).
  /// Negative values move left, positive move right.
  final double minHorizontalVelocity;

  /// The maximum horizontal speed (pixels per second).
  final double maxHorizontalVelocity;

  /// The minimum vertical speed (pixels per second).
  /// Negative values move up, positive move down.
  final double minVerticalVelocity;

  /// The maximum vertical speed (pixels per second).
  final double maxVerticalVelocity;

  @override
  State<ParticleCanvas> createState() => _ParticleCanvasState();
}

/// The [State] class for [ParticleCanvas].
///
/// It uses a [SingleTickerProviderStateMixin] to create and manage a [Ticker]
/// for driving the animation loop.
class _ParticleCanvasState extends State<ParticleCanvas>
    with SingleTickerProviderStateMixin {
  /// The list of [Particle] objects currently being animated.
  List<Particle> particles = [];

  /// A random number generator for initializing particle positions and velocities.
  final Random _random = Random();

  /// The [Ticker] that calls the [_animationLoop] on every frame.
  late Ticker _ticker;

  /// The timestamp of the last animation frame.
  /// Used to calculate `deltaTime` for frame-rate independent animation.
  Duration _lastTick = Duration.zero;

  /// Clean up resources when the widget is removed from the tree.
  @override
  void dispose() {
    _ticker.dispose(); // Stop the ticker to prevent memory leaks
    super.dispose();
  }

  /// Initialize the state when the widget is first created.
  @override
  void initState() {
    super.initState();
    // Create the initial set of particles
    _initializeParticles(Size(widget.width, widget.height));

    // Create a ticker that will call our _animationLoop method
    _ticker = createTicker(_animationLoop);

    // Start the animation
    _ticker.start();
  }

  /// Called when the widget's configuration changes (e.g., parent rebuilds).
  @override
  void didUpdateWidget(ParticleCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool shouldReinitialize = false;

    // Check if properties that require a full reset have changed.
    if (widget.width != oldWidget.width ||
        widget.height != oldWidget.height ||
        widget.numberOfParticles != oldWidget.numberOfParticles) {
      shouldReinitialize = true;
    }

    if (shouldReinitialize) {
      // Re-create all particles if size or count changes.
      _initializeParticles(Size(widget.width, widget.height));
    } else if (widget.color != oldWidget.color) {
      // If only the color changed, just update existing particles.
      // This is more efficient than a full re-initialization.
      _updateParticleColors();
    }
  }

  /// The main animation callback, called by the [Ticker] on each frame.
  void _animationLoop(Duration elapsed) {
    // Calculate the time elapsed since the last frame (in seconds).
    final double deltaTime =
        (elapsed.inMicroseconds - _lastTick.inMicroseconds) /
            Duration.microsecondsPerSecond;
    _lastTick = elapsed; // Store the time for the next frame

    // Update particle positions based on delta time
    _updateParticles(deltaTime);

    // Mark the widget as dirty to trigger a repaint (call build method)
    setState(() {});
  }

  /// Renders the widget.
  @override
  Widget build(BuildContext context) {
    // Use a SizedBox to enforce the dimensions
    return SizedBox(
      width: widget.width,
      height: widget.height,
      // CustomPaint widget uses our ParticlePainter to draw
      child: CustomPaint(
        painter: ParticlePainter(
          particles: particles,
          fadeDirection: widget.fadeDirection,
        ),
      ),
    );
  }

  /// Creates and initializes the `particles` list.
  void _initializeParticles(Size size) {
    particles = List.generate(widget.numberOfParticles, (index) {
      return Particle(
        // Give a random position within the canvas bounds
        position: Offset(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height,
        ),
        color: widget.color,
        radius: widget.particleRadius,
        // Calculate a random velocity within the specified min/max ranges
        velocity: Offset(
          _random.nextDouble() *
                  (widget.maxHorizontalVelocity -
                      widget.minHorizontalVelocity) +
              widget.minHorizontalVelocity,
          _random.nextDouble() *
                  (widget.maxVerticalVelocity - widget.minVerticalVelocity) +
              widget.minVerticalVelocity,
        ),
      );
    });
  }

  /// Updates the position of each particle for the current frame.
  ///
  /// [deltaTime] is the time in seconds since the last frame.
  void _updateParticles(double deltaTime) {
    final size = Size(widget.width, widget.height);

    for (final p in particles) {
      // Calculate the new position based on velocity and delta time.
      // This makes the animation speed independent of the frame rate.
      Offset newPosition = p.position + (p.velocity * deltaTime);

      // --- Boundary Handling (Wrapping) ---
      // This logic makes particles reappear on the opposite side
      // when they go off-screen.

      // Horizontal wrapping
      if (newPosition.dx + p.radius < 0) {
        // Went off the left edge, wrap to the right edge
        newPosition = Offset(size.width + p.radius, newPosition.dy);
      } else if (newPosition.dx - p.radius > size.width) {
        // Went off the right edge, wrap to the left edge
        newPosition = Offset(-p.radius, newPosition.dy);
      }

      // Vertical wrapping
      if (newPosition.dy + p.radius < 0) {
        // Went off the top edge, wrap to the bottom edge
        newPosition = Offset(newPosition.dx, size.height + p.radius);
      } else if (newPosition.dy - p.radius > size.height) {
        // Went off the bottom edge, wrap to the top edge
        newPosition = Offset(newPosition.dx, -p.radius);
      }

      // Apply the updated position to the particle
      p.position = newPosition;
    }
  }

  /// Efficiently updates the color of all existing particles.
  /// Called by [didUpdateWidget] when only `widget.color` changes.
  void _updateParticleColors() {
    for (final p in particles) {
      p.color = widget.color;
    }
  }
}
