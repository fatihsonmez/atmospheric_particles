import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';

import 'package:atmospheric_particles/src/isolate_message.dart';
import 'package:atmospheric_particles/src/particle.dart';

void particleIsolate(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  List<Particle> particles = [];
  Size size = Size.zero;
  Timer? timer;
  Duration lastTick = Duration.zero;

  StreamSubscription? subscription;
  subscription = receivePort.listen((message) {
    if (message == null) {
      timer?.cancel();
      subscription?.cancel();
      receivePort.close();
      Isolate.exit();
    }

    if (message is IsolateMessage) {
      particles = message.particles;
      size = message.size;
      lastTick = Duration.zero;
      timer?.cancel();
      timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
        final elapsed = Duration(milliseconds: 16 * timer.tick);
        final double deltaTime =
            (elapsed.inMicroseconds - lastTick.inMicroseconds) /
                Duration.microsecondsPerSecond;
        lastTick = elapsed;

        if (particles.isNotEmpty) {
          for (final p in particles) {
            Offset newPosition = p.position + (p.velocity * deltaTime);

            if (newPosition.dx + p.radius < 0) {
              newPosition = Offset(size.width + p.radius, newPosition.dy);
            } else if (newPosition.dx - p.radius > size.width) {
              newPosition = Offset(-p.radius, newPosition.dy);
            }

            if (newPosition.dy + p.radius < 0) {
              newPosition = Offset(newPosition.dx, size.height + p.radius);
            } else if (newPosition.dy - p.radius > size.height) {
              newPosition = Offset(newPosition.dx, -p.radius);
            }

            p.position = newPosition;
          }
          sendPort.send(particles);
        }
      });
    }
  });
}
