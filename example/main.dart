import 'package:flutter/material.dart';
import 'package:atmospheric_particles/atmospheric_particles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

List<Color> colors = [
  Colors.red,
  Colors.orange,
  Colors.yellow.shade600,
  Colors.green,
  Colors.blue,
  Colors.deepPurple,
  Colors.purple,
];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _particlesInFront = false;
  int _trailLength = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Particles in Front'),
                    Switch(
                      value: _particlesInFront,
                      onChanged: (value) {
                        setState(() {
                          _particlesInFront = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Trail Length:'),
                    Slider(
                      value: _trailLength.toDouble(),
                      min: 0,
                      max: 50,
                      divisions: 50,
                      label: _trailLength.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _trailLength = value.toInt();
                        });
                      },
                    ),
                    Text(_trailLength.toString()),
                  ],
                ),
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: AtmosphericParticles(
                    fadeDirection: FadeDirection.top,
                    childAlignment: AlignmentGeometry.center,
                    particlesInFront: _particlesInFront,
                    trailLength: _trailLength,
                    child: const Text(
                      'Fade from Top',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: AtmosphericParticles(
                    fadeDirection: FadeDirection.bottom,
                    particleColor: Colors.amber,
                    childAlignment: AlignmentGeometry.center,
                    child: Text(
                      'Fade from Bottom',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: AtmosphericParticles(
                    fadeDirection: FadeDirection.left,
                    particleColor: Colors.lightBlue,
                    childAlignment: AlignmentGeometry.center,
                    child: Text(
                      'Fade from Left',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: AtmosphericParticles(
                    fadeDirection: FadeDirection.right,
                    particleColor: Colors.lightGreen,
                    childAlignment: AlignmentGeometry.center,
                    child: Text(
                      'Fade from Right',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                for (int i = 0; i < 7; i++)
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: AtmosphericParticles(
                      particleColor: colors[i % colors.length],
                      childAlignment: AlignmentGeometry.center,
                      child: const Text(
                        'Hello world!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
