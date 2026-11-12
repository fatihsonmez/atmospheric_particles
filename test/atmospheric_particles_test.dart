// ignore_for_file: implementation_imports

import 'package:atmospheric_particles/src/particle_painter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:atmospheric_particles/atmospheric_particles.dart';
import 'package:atmospheric_particles/src/particle.dart';
import 'package:atmospheric_particles/src/particle_canvas.dart';

void main() {
  testWidgets('AtmosphericParticles renders without errors', (tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: AtmosphericParticles(
          child: Center(
            child: Text('Test'),
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
      const Directionality(
        textDirection: TextDirection.ltr,
        child: AtmosphericParticles(
          fadeDirection: FadeDirection.bottom,
          child: Center(
            child: Text('Test'),
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
      const Directionality(
        textDirection: TextDirection.ltr,
        child: AtmosphericParticles(
          particlesInFront: true,
          child: Text('Child Widget'),
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
    expect(stack.children.last, isA<ClipRect>()); // wraps ParticleCanvas
  });

  testWidgets(
      'AtmosphericParticles places particles in background when particlesInFront is false',
      (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: AtmosphericParticles(
          child: Text('Child Widget'),
        ),
      ),
    );

    final stackFinder = find.descendant(
      of: find.byType(AtmosphericParticles),
      matching: find.byType(Stack),
    );
    final stack = tester.widget<Stack>(stackFinder);

    // When particlesInFront is false, ParticleCanvas should be before the child
    expect(stack.children.first, isA<ClipRect>()); // wraps ParticleCanvas
    expect(stack.children.last, isA<Text>());
  });

  testWidgets('minParticleRadius is passed to ParticleCanvas', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: AtmosphericParticles(
          minParticleRadius: 5.0,
          maxParticleRadius: 10.0,
          child: Text('Child Widget'),
        ),
      ),
    );

    final particleCanvasFinder = find.descendant(
      of: find.byType(AtmosphericParticles),
      matching: find.byType(ParticleCanvas),
    );

    final particleCanvas = tester.widget<ParticleCanvas>(particleCanvasFinder);

    expect(particleCanvas.minParticleRadius, 5.0);
  });

  testWidgets('maxParticleRadius is passed to ParticleCanvas', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: AtmosphericParticles(
          maxParticleRadius: 15.0,
          child: Text('Child Widget'),
        ),
      ),
    );

    final particleCanvasFinder = find.descendant(
      of: find.byType(AtmosphericParticles),
      matching: find.byType(ParticleCanvas),
    );

    final particleCanvas = tester.widget<ParticleCanvas>(particleCanvasFinder);

    expect(particleCanvas.maxParticleRadius, 15.0);
  });

  group('regressions', () {
    List<Particle> particlesOf(WidgetTester t) {
      final cp = t.widget<CustomPaint>(
        find.descendant(
          of: find.byType(AtmosphericParticles),
          matching: find.byType(CustomPaint),
        ),
      );
      return (cp.painter! as ParticlePainter).particles;
    }

    Widget box(double w, double h, Widget child) => Directionality(
          textDirection: TextDirection.ltr,
          child: Center(child: SizedBox(width: w, height: h, child: child)),
        );

    void useLargeView(WidgetTester t) {
      t.view.physicalSize = const Size(10000, 10000);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
    }

    double maxDelta(List<double> a, List<double> b) {
      var m = 0.0;
      for (var i = 0; i < a.length; i++) {
        final d = (a[i] - b[i]).abs();
        if (d > m) m = d;
      }
      return m;
    }

    testWidgets('unbounded height sizes to the child instead of crashing',
        (t) async {
      await t.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: [
              AtmosphericParticles(child: SizedBox(height: 120)),
            ],
          ),
        ),
      );
      await t.pump(const Duration(milliseconds: 100));
      expect(t.takeException(), isNull);
      expect(t.getSize(find.byType(ParticleCanvas)).height, 120);
    });

    testWidgets('changing velocity at runtime takes effect', (t) async {
      useLargeView(t);
      Widget w(double v) => box(
            10000,
            10000,
            AtmosphericParticles(
              particleCount: 50,
              minHorizontalVelocity: v,
              maxHorizontalVelocity: v,
              minVerticalVelocity: 0,
              maxVerticalVelocity: 0,
              child: const SizedBox(),
            ),
          );
      await t.pumpWidget(w(100));
      await t.pump(const Duration(milliseconds: 16));
      await t.pumpWidget(w(0));
      await t.pump(const Duration(milliseconds: 16));
      final before = particlesOf(t).map((p) => p.x).toList();
      for (var i = 0; i < 30; i++) {
        await t.pump(const Duration(milliseconds: 16));
      }
      final after = particlesOf(t).map((p) => p.x).toList();
      expect(maxDelta(before, after), lessThan(1.0));
    });

    testWidgets('particles fill the new area after a resize', (t) async {
      Widget w(double s) => box(
            s,
            s,
            const AtmosphericParticles(
              particleCount: 400,
              minHorizontalVelocity: 0,
              maxHorizontalVelocity: 0,
              minVerticalVelocity: 0,
              maxVerticalVelocity: 0,
              child: SizedBox(),
            ),
          );
      await t.pumpWidget(w(100));
      await t.pump(const Duration(milliseconds: 16));
      await t.pumpWidget(w(400));
      await t.pump(const Duration(milliseconds: 16));
      final ps = particlesOf(t);
      final outside = ps.where((p) => p.x > 100 || p.y > 100).length;
      expect(outside / ps.length, greaterThan(0.5));
    });

    testWidgets('no jump after the ticker is muted and resumed', (t) async {
      useLargeView(t);
      Widget w(bool on) => box(
            10000,
            10000,
            TickerMode(
              enabled: on,
              child: const AtmosphericParticles(
                particleCount: 50,
                minHorizontalVelocity: 0,
                maxHorizontalVelocity: 0,
                minVerticalVelocity: 100,
                maxVerticalVelocity: 100,
                child: SizedBox(),
              ),
            ),
          );
      await t.pumpWidget(w(true));
      await t.pump(const Duration(milliseconds: 16));
      final before = particlesOf(t).map((p) => p.y).toList();
      await t.pumpWidget(w(false));
      await t.pump(const Duration(seconds: 5));
      await t.pumpWidget(w(true));
      await t.pump(const Duration(milliseconds: 16));
      final after = particlesOf(t).map((p) => p.y).toList();
      expect(maxDelta(before, after), lessThan(20));
    });

    testWidgets('particleCount 0 renders and does not schedule frames',
        (t) async {
      await t.pumpWidget(
        box(
          100,
          100,
          const AtmosphericParticles(particleCount: 0, child: SizedBox()),
        ),
      );
      expect(t.takeException(), isNull);
      expect(t.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('reduced motion stops the animation', (t) async {
      await t.pumpWidget(
        box(
          100,
          100,
          const MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: AtmosphericParticles(child: SizedBox()),
          ),
        ),
      );
      expect(t.binding.hasScheduledFrame, isFalse);
    });

    test('shouldRepaint reacts to colour and fade changes', () {
      final repaint = ValueNotifier(0);
      addTearDown(repaint.dispose);
      final ps = <Particle>[];
      ParticlePainter p(Color c, FadeDirection f) => ParticlePainter(
            particles: ps,
            color: c,
            fadeDirection: f,
            repaint: repaint,
          );
      const red = Color(0xFFFF0000);
      expect(
        p(red, FadeDirection.none).shouldRepaint(p(red, FadeDirection.none)),
        isFalse,
      );
      expect(
        p(red, FadeDirection.top).shouldRepaint(p(red, FadeDirection.none)),
        isTrue,
      );
      expect(
        p(const Color(0xFF00FF00), FadeDirection.none)
            .shouldRepaint(p(red, FadeDirection.none)),
        isTrue,
      );
    });
  });
}
