/// A single particle in the animation.
///
/// Holds the current position, velocity, and size of one particle.
/// Fields are mutable because the animation loop updates them in-place
/// every frame to avoid allocations.
class Particle {
  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
  });

  /// Current horizontal position in logical pixels.
  double x;

  /// Current vertical position in logical pixels.
  double y;

  /// Horizontal velocity in logical pixels per second. Positive moves right.
  double vx;

  /// Vertical velocity in logical pixels per second. Positive moves down.
  double vy;

  /// Radius of the particle in logical pixels.
  double radius;
}
