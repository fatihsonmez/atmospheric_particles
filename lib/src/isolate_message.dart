import 'package:atmospheric_particles/src/particle.dart';
import 'package:flutter/material.dart';

class IsolateMessage {
  IsolateMessage({
    required this.particles,
    required this.size,
  });

  final List<Particle> particles;
  final Size size;
}
