import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:atmospheric_particles/src/fade_direction.dart';
import 'package:atmospheric_particles/src/particle.dart';
import 'package:atmospheric_particles/src/particle_painter.dart';

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
    required this.numberOfParticles,
    required this.minParticleRadius,
    required this.maxParticleRadius,
    super.key,
  })  : assert(
          minHorizontalVelocity <= maxHorizontalVelocity,
          'minHorizontalVelocity must be <= maxHorizontalVelocity',
        ),
        assert(
          minVerticalVelocity <= maxVerticalVelocity,
          'minVerticalVelocity must be <= maxVerticalVelocity',
        ),
        assert(
          minParticleRadius <= maxParticleRadius,
          'minParticleRadius must be <= maxParticleRadius',
        );

  final double height;
  final double width;
  final Color color;
  final int numberOfParticles;
  final FadeDirection fadeDirection;
  final double minParticleRadius;
  final double maxParticleRadius;
  final double minHorizontalVelocity;
  final double maxHorizontalVelocity;
  final double minVerticalVelocity;
  final double maxVerticalVelocity;

  @override
  State<ParticleCanvas> createState() => _ParticleCanvasState();
}

class _ParticleCanvasState extends State<ParticleCanvas>
    with SingleTickerProviderStateMixin {
  List<Particle> particles = [];
  final Random _random = Random();

  late Ticker _ticker;
  Duration _lastElapsed = Duration.zero;

  // Controls repainting without rebuilding the widget tree
  final ValueNotifier<int> _repaintNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _initializeParticles();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _repaintNotifier.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    final double dt = (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
    _lastElapsed = elapsed;
    _updateParticles(dt);
    _repaintNotifier.value++;
  }

  void _initializeParticles() {
    particles = List.generate(widget.numberOfParticles, (index) {
      final radius = _random.nextDouble() *
              (widget.maxParticleRadius - widget.minParticleRadius) +
          widget.minParticleRadius;
      return Particle(
        x: _random.nextDouble() * widget.width,
        y: _random.nextDouble() * widget.height,
        radius: radius,
        vx: _random.nextDouble() *
                (widget.maxHorizontalVelocity - widget.minHorizontalVelocity) +
            widget.minHorizontalVelocity,
        vy: _random.nextDouble() *
                (widget.maxVerticalVelocity - widget.minVerticalVelocity) +
            widget.minVerticalVelocity,
      );
    });
  }

  @override
  void didUpdateWidget(ParticleCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only reset if physical particle constraints change
    if (widget.numberOfParticles != oldWidget.numberOfParticles ||
        widget.minParticleRadius != oldWidget.minParticleRadius ||
        widget.maxParticleRadius != oldWidget.maxParticleRadius) {
      _initializeParticles();
    }
  }

  void _updateParticles(double dt) {
    final double w = widget.width;
    final double h = widget.height;

    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];

      // Update positions directly using primitives (Zero allocation)
      p.x += p.vx * dt;
      p.y += p.vy * dt;

      // Boundary wrapping logic
      if (p.x + p.radius < 0) {
        p.x = w + p.radius;
      } else if (p.x - p.radius > w) {
        p.x = -p.radius;
      }

      if (p.y + p.radius < 0) {
        p.y = h + p.radius;
      } else if (p.y - p.radius > h) {
        p.y = -p.radius;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: ParticlePainter(
            particles: particles,
            fadeDirection: widget.fadeDirection,
            repaint: _repaintNotifier,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}
