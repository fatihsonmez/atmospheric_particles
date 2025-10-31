import 'package:atmospheric_particles/atmospheric_particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Sandbox(),
    );
  }
}

class Sandbox extends StatefulWidget {
  const Sandbox({super.key});

  @override
  State<Sandbox> createState() => _SandboxState();
}

class _SandboxState extends State<Sandbox> {
  double particleCount = 100;
  FadeDirection fadeDirection = FadeDirection.bottom;
  double minVertical = 100;
  double maxVertical = 200;
  double minHorizontal = 60;
  double maxHorizontal = 80;
  double trailLength = 0;

  late double _tempParticleCount;
  late double _tempMinVertical;
  late double _tempMaxVertical;
  late double _tempMinHorizontal;
  late double _tempMaxHorizontal;
  late double _tempTrailLength;

  @override
  void initState() {
    super.initState();
    _tempParticleCount = particleCount;
    _tempMinVertical = minVertical;
    _tempMaxVertical = maxVertical;
    _tempMinHorizontal = minHorizontal;
    _tempMaxHorizontal = maxHorizontal;
    _tempTrailLength = trailLength;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: AtmosphericParticles(
              key: ValueKey(
                '$particleCount-$fadeDirection-$minVertical-$maxVertical-$minHorizontal-$maxHorizontal-$trailLength',
              ),
              particleCount: particleCount.toInt(),
              fadeDirection: fadeDirection,
              minVerticalVelocity: minVertical,
              maxVerticalVelocity: maxVertical,
              minHorizontalVelocity: minHorizontal,
              maxHorizontalVelocity: maxHorizontal,
              particleColor: const Color(0xffff0000),
              trailLength: trailLength.toInt(),
              height: MediaQuery.of(context).size.height,
              child: const SizedBox(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[900],
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSlider('Particle Count', _tempParticleCount, 10, 1000,
                      (val) {
                    setState(() => _tempParticleCount = val);
                  }, (val) {
                    setState(() => particleCount = val);
                  }),
                  _buildChips(
                      'Fade Direction', FadeDirection.values, fadeDirection,
                      (val) {
                    setState(() => fadeDirection = val);
                  }),
                  _buildSlider('Min Vertical', _tempMinVertical, -500, 500,
                      (val) {
                    setState(
                      () => _tempMinVertical = val.clamp(-500, maxVertical),
                    );
                  }, (val) {
                    setState(() => minVertical = val.clamp(-500, maxVertical));
                  }),
                  _buildSlider('Max Vertical', _tempMaxVertical, -500, 500,
                      (val) {
                    setState(
                      () => _tempMaxVertical = val.clamp(minVertical, 500),
                    );
                  }, (val) {
                    setState(() => maxVertical = val.clamp(minVertical, 500));
                  }),
                  _buildSlider('Min Horizontal', _tempMinHorizontal, -500, 500,
                      (val) {
                    setState(
                      () => _tempMinHorizontal = val.clamp(-500, maxHorizontal),
                    );
                  }, (val) {
                    setState(
                      () => minHorizontal = val.clamp(-500, maxHorizontal),
                    );
                  }),
                  _buildSlider('Max Horizontal', _tempMaxHorizontal, -500, 500,
                      (val) {
                    setState(
                      () => _tempMaxHorizontal = val.clamp(minHorizontal, 500),
                    );
                  }, (val) {
                    setState(
                      () => maxHorizontal = val.clamp(minHorizontal, 500),
                    );
                  }),
                  _buildSlider('Trail Length', _tempTrailLength, 0, 100, (val) {
                    setState(() => _tempTrailLength = val);
                  }, (val) {
                    setState(() => trailLength = val);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
    ValueChanged<double> onChangeEnd,
  ) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
          ),
        ),
        Text(
          value.toInt().toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildChips<T>(
    String label,
    List<T> options,
    T selected,
    ValueChanged<T> onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: options.map((option) {
            return ChoiceChip(
              selectedColor: Theme.of(context).primaryColor,
              showCheckmark: false,
              label: Text(
                option.toString().split('.').last,
                style: TextStyle(
                  color: option == selected ? Colors.white : Colors.black,
                ),
              ),
              selected: selected == option,
              onSelected: (_) => onSelected(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}
