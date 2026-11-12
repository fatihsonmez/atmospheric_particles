import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'package:atmospheric_particles/src/fade_direction.dart';
import 'package:atmospheric_particles/src/particle.dart';

/// A [CustomPainter] responsible for drawing a list of [Particle] objects
/// onto a [Canvas].
///
/// Particles are expected to be sorted by radius. Each run of equal radius is
/// drawn with a single [Canvas.drawRawPoints] call using round caps, and the
/// fade is applied with one gradient shader instead of a colour per particle.
class ParticlePainter extends CustomPainter {
  ParticlePainter({
    required this.particles,
    required this.color,
    required Listenable repaint,
    this.fadeDirection = FadeDirection.none,
  }) : super(repaint: repaint);

  final List<Particle> particles;
  final FadeDirection fadeDirection;
  final Color color;

  final Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  // Reused between frames; holds x,y pairs for one radius batch.
  late final Float32List _points = Float32List(particles.length * 2);

  ui.Shader? _shader;
  Size _shaderSize = Size.zero;

  /// Gradient that is transparent at the faded edge and [color] at the other.
  ui.Shader? _fadeShader(Size size) {
    if (fadeDirection == FadeDirection.none) return null;
    final (Offset from, Offset to) = switch (fadeDirection) {
      FadeDirection.top => (Offset.zero, Offset(0, size.height)),
      FadeDirection.bottom => (Offset(0, size.height), Offset.zero),
      FadeDirection.left => (Offset.zero, Offset(size.width, 0)),
      FadeDirection.right => (Offset(size.width, 0), Offset.zero),
      FadeDirection.none => (Offset.zero, Offset.zero),
    };
    if (_shader == null || _shaderSize != size) {
      _shaderSize = size;
      // Same RGB at both stops, so only alpha is interpolated. The colour's own
      // alpha is kept as the maximum.
      _shader = ui.Gradient.linear(from, to, [color.withAlpha(0), color]);
    }
    return _shader;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (particles.isEmpty) return;
    _paint
      ..color = color
      ..shader = _fadeShader(size);

    final points = _points;
    int start = 0;
    while (start < particles.length) {
      final radius = particles[start].radius;
      int n = 0;
      int i = start;
      for (; i < particles.length; i++) {
        final p = particles[i];
        if (p.radius != radius) break;
        points[n++] = p.x;
        points[n++] = p.y;
      }
      _paint.strokeWidth = radius * 2;
      canvas.drawRawPoints(
        ui.PointMode.points,
        Float32List.sublistView(points, 0, n),
        _paint,
      );
      start = i;
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) =>
      !identical(oldDelegate.particles, particles) ||
      oldDelegate.color != color ||
      oldDelegate.fadeDirection != fadeDirection;
}
