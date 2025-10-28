// ignore_for_file: implementation_imports

import 'package:atmospheric_particles/src/particle_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:atmospheric_particles/atmospheric_particles.dart';

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
}
