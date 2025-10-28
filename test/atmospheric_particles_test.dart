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
}
