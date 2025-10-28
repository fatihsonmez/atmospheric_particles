// ignore_for_file: implementation_imports

import 'package:atmospheric_particles/src/particle_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:atmospheric_particles/atmospheric_particles.dart';
import 'package:atmospheric_particles/src/particle_canvas.dart';

void main() {
  testWidgets('AtmosphericParticles renders without errors', (tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AtmosphericParticles(
            child: Center(
              child: Text('Test'),
            ),
          ),
        ),
      ),
    );

    // Verify that the AtmosphericParticles widget is present.
    expect(find.byType(AtmosphericParticles), findsOneWidget);

    // Pump a frame to simulate the animation.
    await tester.pump(const Duration(seconds: 1));

    // Verify that no exceptions were thrown.
    expect(tester.takeException(), isNull);
  });

  testWidgets('fadeDirection is passed to ParticlePainter', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AtmosphericParticles(
            fadeDirection: FadeDirection.bottom,
            child: Center(
              child: Text('Test'),
            ),
          ),
        ),
      ),
    );

    final customPaintFinder = find.descendant(
      of: find.byType(AtmosphericParticles),
      matching: find.byType(CustomPaint),
    );

    final customPaint = tester.widget<CustomPaint>(customPaintFinder);
    final painter = customPaint.painter as ParticlePainter;

    expect(painter.fadeDirection, FadeDirection.bottom);
  });

  testWidgets(
      'AtmosphericParticles places particles in front when particlesInFront is true',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AtmosphericParticles(
            particlesInFront: true,
            child: Text('Child Widget'),
          ),
        ),
      ),
    );

    final stackFinder = find.descendant(
      of: find.byType(AtmosphericParticles),
      matching: find.byType(Stack),
    );
    final stack = tester.widget<Stack>(stackFinder);

    // When particlesInFront is true, ParticleCanvas should be after the child
    expect(stack.children.first, isA<Text>());
    expect(stack.children.last, isA<ClipRRect>()); // ClipRRect wraps ParticleCanvas
  });

  testWidgets(
      'AtmosphericParticles places particles in background when particlesInFront is false',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AtmosphericParticles(
            particlesInFront: false,
            child: Text('Child Widget'),
          ),
        ),
      ),
    );

    final stackFinder = find.descendant(
      of: find.byType(AtmosphericParticles),
      matching: find.byType(Stack),
    );
    final stack = tester.widget<Stack>(stackFinder);

    // When particlesInFront is false, ParticleCanvas should be before the child
    expect(stack.children.first, isA<ClipRRect>()); // ClipRRect wraps ParticleCanvas
    expect(stack.children.last, isA<Text>());
  });

  testWidgets('trailLength is passed to ParticleCanvas', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AtmosphericParticles(
            trailLength: 10,
            child: Text('Child Widget'),
          ),
        ),
      ),
    );

    final particleCanvasFinder = find.descendant(
      of: find.byType(AtmosphericParticles),
      matching: find.byType(ParticleCanvas),
    );

    final particleCanvas = tester.widget<ParticleCanvas>(particleCanvasFinder);

    expect(particleCanvas.trailLength, 10);
  });
}
