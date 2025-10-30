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
  double _minParticleRadius = 2;
  double _maxParticleRadius = 2;

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
                      max: 50,
                      divisions: 50,
                      label: _trailLength.toString(),
                      onChanged: (value) {
                        setState(() {
                          _trailLength = value.toInt();
                        });
                      },
                    ),
                    Text(_trailLength.toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Min Particle Radius:'),
                    Slider(
                      value: _minParticleRadius,
                      min: 0.1,
                      max: 10.0,
                      divisions: 99,
                      label: _minParticleRadius.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() {
                          _minParticleRadius = value;
                          if (_minParticleRadius > _maxParticleRadius) {
                            _maxParticleRadius = _minParticleRadius;
                          }
                        });
                      },
                    ),
                    Text(_minParticleRadius.toStringAsFixed(1)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Max Particle Radius:'),
                    Slider(
                      value: _maxParticleRadius,
                      min: 0.1,
                      max: 10.0,
                      divisions: 99,
                      label: _maxParticleRadius.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() {
                          _maxParticleRadius = value;
                          if (_maxParticleRadius < _minParticleRadius) {
                            _minParticleRadius = _maxParticleRadius;
                          }
                        });
                      },
                    ),
                    Text(_maxParticleRadius.toStringAsFixed(1)),
                  ],
                ),
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: AtmosphericParticles(
                    fadeDirection: FadeDirection.top,
                    childAlignment: Alignment.center,
                    particlesInFront: _particlesInFront,
                    trailLength: _trailLength,
                    minParticleRadius: _minParticleRadius,
                    maxParticleRadius: _maxParticleRadius,
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
                    childAlignment: Alignment.center,
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
                    childAlignment: Alignment.center,
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
                    childAlignment: Alignment.center,
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
                      childAlignment: Alignment.center,
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
