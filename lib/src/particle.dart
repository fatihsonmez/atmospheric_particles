import 'package:flutter/material.dart';
import 'package:atmospheric_particles/src/particle_shape.dart';

/// Represents a single particle in the animation.
///
/// This class holds all the necessary information to draw and animate
/// a particle on the canvas, including its current position,
/// color, size (radius), and velocity.
class Particle {
  /// Creates an instance of a [Particle].
  ///
  /// All parameters are required.
  Particle({
    required this.position,
    required this.color,
    required this.radius,
    required this.velocity,
    required this.maxHistoryLength,
    this.shape,
    this.image,
  }) : history = [position];

  /// The current (x, y) coordinates of the particle on the canvas.
  Offset position;

  /// The color of the particle.
  Color color;

  /// The radius of the particle, determining its size.
  double radius;

  /// The particle's velocity, represented as an [Offset].
  ///
  /// The [Offset.dx] controls horizontal speed and direction (negative for left, positive for right).
  /// The [Offset.dy] controls vertical speed and direction (negative for up, positive for down).
  Offset velocity;

  /// A list of past positions to create a trail effect.
  final List<Offset> history;

  /// The maximum number of past positions to store for the trail.
  final int maxHistoryLength;

  /// The shape of the particle. If null, and [image] is also null, defaults to [ParticleShape.circle].
  final ParticleShape? shape;

  /// The image to use for the particle. If provided, overrides [shape].
  final ImageProvider? image;
}
