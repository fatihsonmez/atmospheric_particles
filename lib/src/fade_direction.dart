/// Controls the direction of the opacity gradient applied to particles.
///
/// When a fade direction is set, particles become transparent as they approach
/// the corresponding edge of the canvas and fully opaque at the opposite edge.
enum FadeDirection {
  /// Particles fade out toward the top edge (transparent at top, opaque at bottom).
  top,

  /// Particles fade out toward the bottom edge (transparent at bottom, opaque at top).
  bottom,

  /// Particles fade out toward the left edge (transparent at left, opaque at right).
  left,

  /// Particles fade out toward the right edge (transparent at right, opaque at left).
  right,

  /// No fade effect is applied. All particles are drawn at full opacity.
  none,
}
