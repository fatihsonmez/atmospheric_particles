import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:atmospheric_particles/src/fade_direction.dart';
import 'package:atmospheric_particles/src/isolate_message.dart';
import 'package:atmospheric_particles/src/particle.dart';
import 'package:atmospheric_particles/src/particle_isolate.dart';
import 'package:atmospheric_particles/src/particle_painter.dart';

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
    required this.numberOfParticles,
    required this.particleRadius,
    super.key,
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
/// It uses a long-lived Isolate to offload the animation logic and keep the UI
/// thread free.
class _ParticleCanvasState extends State<ParticleCanvas> {
  /// The list of [Particle] objects currently being animated.
  List<Particle> particles = [];

  /// A random number generator for initializing particle positions and velocities.
  final Random _random = Random();

  /// The isolate where the particle animation logic runs.
  // ignore: unused_field
  Isolate? _isolate;

  /// The port to send messages to the isolate.
  SendPort? _sendPort;

  /// The subscription to the isolate's message stream.
  StreamSubscription<dynamic>? _isolateSubscription;

  /// The ReceivePort to listen for the isolate's exit message.
  ReceivePort? _onExitPort;

  /// Clean up resources when the widget is removed from the tree.
  @override
  void dispose() {
    _sendPort?.send(null);
    _isolateSubscription?.cancel();
    _onExitPort?.first.then((_) {
      _onExitPort?.close();
    });
    super.dispose();
  }

  /// Initialize the state when the widget is first created.
  @override
  void initState() {
    super.initState();
    _spawnIsolate();
  }

  void _spawnIsolate() async {
    final receivePort = ReceivePort();
    _onExitPort = ReceivePort();
    _isolateSubscription = receivePort.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
        // Once we have the send port, we can initialize the particles
        // and send them to the isolate.
        _initializeAndSendParticles();
      } else if (message is List<Particle>) {
        // When we receive a new list of particles from the isolate,
        // we update the state to trigger a repaint.
        if (mounted) {
          setState(() {
            particles = message;
          });
        }
      }
    });
    _isolate = await Isolate.spawn(
      particleIsolate,
      receivePort.sendPort,
      onExit: _onExitPort!.sendPort,
    );
  }

  void _initializeAndSendParticles() {
    final size = Size(widget.width, widget.height);
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
    _sendPort?.send(IsolateMessage(particles: particles, size: size));
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
      _initializeAndSendParticles();
    } else if (widget.color != oldWidget.color) {
      // If only the color changed, just update existing particles.
      // This is more efficient than a full re-initialization.
      _updateParticleColors();
    }
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

  /// Efficiently updates the color of all existing particles.
  /// Called by [didUpdateWidget] when only `widget.color` changes.
  void _updateParticleColors() {
    for (final p in particles) {
      p.color = widget.color;
    }
    _sendPort?.send(
      IsolateMessage(
        particles: particles,
        size: Size(widget.width, widget.height),
      ),
    );
  }
}
