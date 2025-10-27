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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              for (int i = 0; i < 15; i++)
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
    );
  }
}
