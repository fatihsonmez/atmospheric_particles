
# atmospheric_particles

A lightweight, highly customizable Flutter package for creating beautiful particle animations in the background of any widget.

<p float="left">
<img src="https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExaXZ5aWZtbTdwd21oY3ZnZ2UydWhlZXZvdXdmbXlkZGo1M283YmVnMSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/eLGnnTMU3MKREaAkXD/giphy.gif" height="600" /> 
<img src="https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExOG4wYTM1aTI4ZW5hM3VheTB4MGQ4Y2Zmc2Z5a2lxbnlhaGhnb2thcCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/1JgEFkYsCLK3mdtbR2/giphy.gif" height="600" /> 

</p>


## Features

* **Highly Customizable:** Control particle color, size, count, and speed.
* **Directional Control:** Set minimum and maximum velocities for both horizontal and vertical axes.
* **Directional Fade:** Apply a fade effect from the top, bottom, left, or right.
* **Lightweight:** Simple and efficient, designed to wrap any widget without performance issues.
* **Easy to Use:** Get started immediately with beautiful default parameters.

## Getting Started

### 1. Installation

Add the package to your `pubspec.yaml` file:

```yaml
dependencies:
  atmospheric_particles: ^1.0.0
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
// ... inside your build method
SizedBox(
  height: 100,
  width: double.infinity,
  child: AtmosphericParticles(
    particleColor: Colors.blue,
    minParticleRadius: 2,
    maxParticleRadius: 4,
    particleCount: 100,
    fadeDirection: FadeDirection.bottom,
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
| **`child`** | `Widget` | The widget to display on top of (or behind) the particle field. |
| **`childAlignment`** | `AlignmentGeometry` | How the `child` is aligned within the stack. Defaults to `Alignment.topCenter`. |
| **`fadeDirection`** | `FadeDirection` | The direction of the opacity gradient. Can be `FadeDirection.top`, `bottom`, `left`, `right`, or `none`. Defaults to `FadeDirection.none`. |
| **`particleColor`** | `Color` | The color of the particles. Alpha is respected — pass a color with opacity to make all particles semi-transparent. Defaults to `Colors.deepPurple`. |
| **`particleCount`** | `int` | The total number of particles to render. Defaults to `200`. |
| **`minParticleRadius`** | `double` | The minimum radius of each particle. Must be greater than `0`. Defaults to `2`. |
| **`maxParticleRadius`** | `double` | The maximum radius of each particle. Defaults to `2`. |
| **`minVerticalVelocity`** | `double` | The minimum vertical speed in pixels per second. Negative values move upward. Defaults to `-100`. |
| **`maxVerticalVelocity`** | `double` | The maximum vertical speed in pixels per second. Negative values move upward. Defaults to `-20`. |
| **`minHorizontalVelocity`** | `double` | The minimum horizontal speed in pixels per second. Negative values move left. Defaults to `10`. |
| **`maxHorizontalVelocity`** | `double` | The maximum horizontal speed in pixels per second. Negative values move left. Defaults to `30`. |
| **`width`** | `double` | Width of the particle canvas. Defaults to `double.infinity` (fills available width). |
| **`height`** | `double` | Height of the particle canvas. Defaults to `double.infinity` (fills available height). |
| **`particlesInFront`** | `bool` | Whether the particles should be rendered in front of the child widget. Defaults to `false`. |

## Additional Information

### Have Suggestions or Find a Bug?

If you have any suggestions or encounter a bug, we'd love to hear from you!

  * **Visit the GitHub Repository:** For the source code, to see existing issues, or to learn more about the project: [atmospheric\_particles on GitHub](https://github.com/fatihsonmez/atmospheric_particles)
  * **Open an Issue on GitHub:** This is the preferred method for tracking bugs and feature requests.
  * Email me at fatih.sonmez@bosphorusiss.com

### License

This package is licensed under the [The 3-Clause BSD License](https://opensource.org/license/BSD-3-Clause).
