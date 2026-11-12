import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:atmospheric_particles/src/fade_direction.dart';
import 'package:atmospheric_particles/src/particle.dart';
import 'package:atmospheric_particles/src/particle_painter.dart';

/// Longest time step applied in a single frame, in seconds.
///
/// When the ticker is muted (e.g. another route covers this one) the elapsed
/// time keeps growing. Without a cap, the first frame after resuming would
/// move every particle by the whole paused duration.
const double _maxFrameDt = 0.05;

/// Radii are rounded to this step so the painter can batch equal-sized
/// particles into a single draw call. 0.25 logical pixels is not visible.
const double _radiusStep = 0.25;

/// Animates and paints the particles. Validation of the parameters happens in
/// [AtmosphericParticles]; this widget is internal to the package.
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
  });

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

  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  bool _reduceMotion = false;

  // Controls repainting without rebuilding the widget tree
  final ValueNotifier<int> _repaintNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _initializeParticles();
    _ticker = createTicker(_onTick);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    _syncTicker();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _repaintNotifier.dispose();
    super.dispose();
  }

  /// Runs the ticker only when there is something to animate.
  void _syncTicker() {
    final shouldRun = !_reduceMotion && particles.isNotEmpty;
    if (shouldRun && !_ticker.isActive) {
      _lastElapsed = Duration.zero;
      _ticker.start();
    } else if (!shouldRun && _ticker.isActive) {
      _ticker.stop();
    }
  }

  void _onTick(Duration elapsed) {
    double dt = (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
    _lastElapsed = elapsed;
    if (dt > _maxFrameDt) dt = _maxFrameDt;
    _updateParticles(dt);
    _repaintNotifier.value++;
  }

  double _between(double min, double max) =>
      _random.nextDouble() * (max - min) + min;

  double _randomRadius() {
    final min = widget.minParticleRadius;
    final max = widget.maxParticleRadius;
    final r = (_between(min, max) / _radiusStep).round() * _radiusStep;
    return r.clamp(min, max);
  }

  void _initializeParticles() {
    particles = List.generate(widget.numberOfParticles, (_) {
      return Particle(
        x: _random.nextDouble() * widget.width,
        y: _random.nextDouble() * widget.height,
        radius: _randomRadius(),
        vx: _between(
          widget.minHorizontalVelocity,
          widget.maxHorizontalVelocity,
        ),
        vy: _between(widget.minVerticalVelocity, widget.maxVerticalVelocity),
      );
    });
    // Sorted by radius so the painter can draw each size in one batch.
    particles.sort((a, b) => a.radius.compareTo(b.radius));
  }

  void _rerollVelocities() {
    for (final p in particles) {
      p.vx =
          _between(widget.minHorizontalVelocity, widget.maxHorizontalVelocity);
      p.vy = _between(widget.minVerticalVelocity, widget.maxVerticalVelocity);
    }
  }

  /// Keeps the particle distribution when the canvas is resized.
  void _rescalePositions(double oldWidth, double oldHeight) {
    for (final p in particles) {
      p.x = oldWidth > 0
          ? p.x * widget.width / oldWidth
          : _random.nextDouble() * widget.width;
      p.y = oldHeight > 0
          ? p.y * widget.height / oldHeight
          : _random.nextDouble() * widget.height;
    }
  }

  @override
  void didUpdateWidget(ParticleCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.numberOfParticles != oldWidget.numberOfParticles ||
        widget.minParticleRadius != oldWidget.minParticleRadius ||
        widget.maxParticleRadius != oldWidget.maxParticleRadius) {
      // Creates new random velocities and positions for the current size too.
      _initializeParticles();
      _syncTicker();
      return;
    }

    if (widget.minHorizontalVelocity != oldWidget.minHorizontalVelocity ||
        widget.maxHorizontalVelocity != oldWidget.maxHorizontalVelocity ||
        widget.minVerticalVelocity != oldWidget.minVerticalVelocity ||
        widget.maxVerticalVelocity != oldWidget.maxVerticalVelocity) {
      _rerollVelocities();
    }

    if (widget.width != oldWidget.width || widget.height != oldWidget.height) {
      _rescalePositions(oldWidget.width, oldWidget.height);
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
