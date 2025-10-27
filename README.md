
# atmospheric_particles

A lightweight, highly customizable Flutter package for creating beautiful particle animations in the background of any widget.

---

![screenshot](https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExdWxpYTVtbzhjdjI2a2d1dWxxMmJ3bjQwYXdnOWRxMzV6d25tcDYwcyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/70XAgXZr1ooT862yFx/giphy.gif)

---

## Features

* **Highly Customizable:** Control particle color, size, count, and speed.
* **Directional Control:** Set minimum and maximum velocities for both horizontal and vertical axes.
* **Lightweight:** Simple and efficient, designed to wrap any widget without performance issues.
* **Easy to Use:** Get started immediately with beautiful default parameters.

## Getting Started

### 1. Installation

Add the package to your `pubspec.yaml` file:

```yaml
dependencies:
  atmospheric_particles: ^0.0.1 
````

Or, run this command in your terminal:

```bash
flutter pub add atmospheric_particles
```

### 2\. Import

Import the package into your Dart file:

```dart
import 'package:atmospheric_particles/atmospheric_particles.dart';
```

## Usage

The `AtmosphericParticles` widget can be wrapped around any widget. It works best inside a `SizedBox` or `Container` to give it explicit dimensions.

### Basic Example

This will create a particle field using the beautiful default parameters.

```dart
SizedBox(
  height: 200,
  width: double.infinity,
  child: AtmosphericParticles(
    child: Center(
      child: Text(
        'Hello Particles!',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    ),
  ),
)
```

### Advanced Customization Example

You can customize nearly every aspect of the particle field.

```dart
List<Color> colors = [
  Colors.red,
  Colors.orange,
  Colors.yellow.shade600,
  Colors.green,
  Colors.blue,
  Colors.deepPurple,
  Colors.purple,
];

// ... inside your build method
for(int i = 0; i < 10; i++)
    SizedBox(
        height: 50,
        width: double.infinity,
        child: AtmosphericParticles(
            particleColor: colors[i % colors.length],
            particleRadius: 3,
            particleCount: 100,
            minVerticalVelocity: -30,
            maxVerticalVelocity: -10,
            minHorizontalVelocity: -30,
            maxHorizontalVelocity: -10,
            child: const Center(child: Text('Customized Particles')),
        ),
    ),
```

## Widget Properties (API)

| Property | Type | Description |
| :--- | :--- | :--- |
| **`child`** | `Widget` | The widget to display in front of the particle field. |
| **`particleColor`** | `Color` | The color of the particles. Defaults to `Colors.purple` with opacity. |
| **`particleCount`** | `int` | The total number of particles to render. Defaults to `200`. |
| **`particleRadius`** | `double` | The radius of each particle. Defaults to `2`. |
| **`minVerticalVelocity`** | `double` | The minimum *upward* speed. (Use negative values for upward motion). Defaults to `-100`. |
| **`maxVerticalVelocity`** | `double` | The maximum *upward* speed. (Use negative values for upward motion). Defaults to `-20`. |
| **`minHorizontalVelocity`** | `double` | The minimum *horizontal* speed. (Negative for left, positive for right). Defaults to `10`. |
| **`maxHorizontalVelocity`** | `double` | The maximum *horizontal* speed. (Negative for left, positive for right). Defaults to `30`. |

## Additional Information

### Have Suggestions or Find a Bug?

If you have any suggestions or encounter a bug, please feel free to:
  * Email me at fatih.sonmez@bosphorusiss.com

### License

This package is licensed under the [The 3-Clause BSD License](https://opensource.org/license/BSD-3-Clause).
