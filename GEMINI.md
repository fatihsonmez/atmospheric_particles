# GEMINI.md

## Project Overview

This is a Flutter package named `atmospheric_particles`. It provides a highly customizable widget for creating beautiful and lightweight particle animations in the background of any widget. The main widget is `AtmosphericParticles`, which allows for control over particle color, size, count, speed, and direction.

The project is written in Dart and follows the standard Flutter project structure. The main source code is located in the `lib` directory, with the primary widget being `AtmosphericParticles` in `lib/atmospheric_particles.dart`. An example implementation is available in `example/main.dart`.

## Building and Running

### Dependencies

The project depends on the Flutter SDK. Dependencies are managed in the `pubspec.yaml` file.

### Running the Example

To run the example application:

1.  Navigate to the `example` directory: `cd example`
2.  Install dependencies: `flutter pub get`
3.  Run the app: `flutter run`

### Running Tests

The project uses `flutter_test` for testing. To run tests:

```bash
flutter test
```

## Development Conventions

### Coding Style

The project follows the standard Dart and Flutter coding styles, enforced by the `flutter_lints` package as defined in `analysis_options.yaml`. Key conventions include:

*   Use of `const` where possible.
*   Adherence to Dartdoc comments for all public APIs.
*   Proper formatting and linting as per the `flutter_lints` rules.

### Project Structure

*   `lib/`: Contains the main source code for the package.
    *   `atmospheric_particles.dart`: The main widget and public API.
    *   `particle_canvas.dart`: The canvas where the particles are drawn.
    *   `particle_painter.dart`: The `CustomPainter` for drawing the particles.
    *   `particle.dart`: The data model for a single particle.
*   `example/`: Contains an example Flutter application demonstrating the package's usage.
*   `pubspec.yaml`: Defines the package metadata and dependencies.
*   `analysis_options.yaml`: Configures the Dart analyzer and linter.
