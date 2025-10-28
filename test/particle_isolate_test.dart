import 'dart:async';
import 'dart:isolate';

import 'package:atmospheric_particles/src/isolate_message.dart';
import 'package:atmospheric_particles/src/particle.dart';
import 'package:atmospheric_particles/src/particle_isolate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Particle isolate initializes, updates, and shuts down', () async {
    final receivePort = ReceivePort();
    final onExitPort = ReceivePort();
    final isolate = await Isolate.spawn(
      particleIsolate,
      receivePort.sendPort,
      onExit: onExitPort.sendPort,
    );

    final sendPortCompleter = Completer<SendPort>();
    final particleUpdates = StreamController<List<Particle>>();

    receivePort.listen((message) {
      if (message is SendPort) {
        sendPortCompleter.complete(message);
      } else if (message is List<Particle>) {
        particleUpdates.add(message);
      }
    });

    final sendPort = await sendPortCompleter.future;

    final particles = [
      Particle(
        position: Offset.zero,
        velocity: const Offset(1, 1),
        color: Colors.red,
        radius: 1,
      ),
    ];
    final message = IsolateMessage(particles: particles, size: const Size(100, 100));

    sendPort.send(message);

    // Expect to receive at least one updated particle list.
    final updatedParticles = await particleUpdates.stream.first;
    expect(updatedParticles.length, 1);
    expect(updatedParticles[0].position, isNot(Offset.zero));

    // Send shutdown message.
    sendPort.send(null);

    // Wait for the isolate to shut down.
    await onExitPort.first;

    isolate.kill(priority: Isolate.immediate);
    receivePort.close();
    onExitPort.close();
    await particleUpdates.close();
  });
}
