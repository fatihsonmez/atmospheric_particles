## [1.1.0]

#### Fixed
* No longer crashes inside a `Column`, `Row` or scroll view. When the parent gives unbounded constraints, the particle canvas now takes the size of `child`.
* Changing `minHorizontalVelocity`, `maxHorizontalVelocity`, `minVerticalVelocity` or `maxVerticalVelocity` at runtime now takes effect immediately, without recreating the widget.
* Particles now spread over the new area when the widget is resized (e.g. window resize or device rotation) instead of staying in the old area.
* Particles no longer jump when the animation resumes after being paused (e.g. when another route was on top). The time step per frame is now capped.
* Changing `particleColor` or `fadeDirection` now always repaints.

#### Changed
* Rendering is much faster: particles of the same size are drawn in a single batch, and the fade is applied with one gradient instead of a color per particle. At 20,000 particles, raster time per frame dropped from about 19.5 ms to under 3 ms in our benchmark (macOS, profile mode), and the animation keeps 60 fps.
* Particle radii are rounded to 0.25 logical pixels so equal sizes can be batched. The difference is not visible.
* `particleCount` may now be `0`, which shows no particles and stops the animation.
* The animation stops when the platform asks to reduce motion (`MediaQuery.disableAnimations`).
* The package now depends only on `package:flutter/widgets.dart` instead of the deprecated `package:flutter/material.dart`. The default `particleColor` is unchanged (`Color(0xFF673AB7)`, deep purple).
* Minimum versions raised to Flutter 3.27 / Dart 3.6, which the code already required (`Color.toARGB32()`, switch expressions).

#### Tests
* Fixed two tests that expected a `ClipRRect` instead of a `ClipRect`.
* Added regression tests for each fix above.

## [1.0.0]

#### Fixed
* `particleColor` alpha is now respected when combined with `fadeDirection`. Previously the fade effect overwrote the color's own opacity; it now multiplies the two alphas so a semi-transparent color fades correctly.

#### Changed
* Deprecated `Color.value` usage replaced with `Color.toARGB32()`.

#### Documentation
* `FadeDirection` enum values now clearly describe which edge becomes transparent and which stays opaque.
* `Particle` class and all its fields are now documented.
* README: removed stale `trailLength` parameter (removed in v0.4.0), fixed advanced example that referenced the removed `particleRadius` property, added missing `childAlignment`, `width`, and `height` entries to the API table, corrected `particleColor` description to mention alpha support.
* Corrected CHANGELOG entry for v0.3.2 to accurately reflect the `AlignmentGeometry` type change.

## [0.4.0]

#### Removed
* Removed Isolate for better performance.
* Used basic types for better performance.
* Removed trail length for better performance.

## [0.3.6]

#### Added
* Removed unused particle shape enum.

## [0.3.5]

#### Added
* Added an interactive sandbox for particle customization.

## [0.3.4]

#### Changed
* Improved code style, formatting, and readability across the project.
* Enhanced null safety in `particle_canvas.dart`.
* Minor cleanups in the example app and `README.md`.

## [0.3.3]

#### Fixed
* A bug where the fade effect was not correctly applied to particle trails.
* A bug where the fade effect would jump when particles wrapped around the screen. The fade is now calculated per-segment for a smooth effect.

## [0.3.2]

#### Changed
* **Refactor:** Typed `childAlignment` as `AlignmentGeometry` (the Flutter base type for alignment values) to allow both `Alignment` and `AlignmentDirectional` to be passed.

## [0.3.1]

#### Changed
* Refactored `AtmosphericParticles` to use default values for constructor parameters, improving maintainability.
* Added input validation assertions to `AtmosphericParticles` to prevent invalid parameter combinations.

## [0.3.0]

#### Added
* Added `minParticleRadius` and `maxParticleRadius` properties to `AtmosphericParticles` to allow for particle size variation.

#### Changed
* **Breaking Change:** Replaced `particleRadius` with `minParticleRadius` and `maxParticleRadius` in `AtmosphericParticles`.

## [0.2.4]

#### Added
* Added `particleShape` property to `AtmosphericParticles` to allow customization of particle shapes (circle, square, triangle, oval, rrect).

## [0.2.3]

#### Added
* Added `trailLength` property to `AtmosphericParticles` to enable and control the length of particle trails.

## [0.2.2]

#### Added
* Added `particlesInFront` property to `AtmosphericParticles` to control whether particles are rendered in front of or behind the child widget.

## [0.2.1]

#### Fixed
* Particle isolate test hanging due to improper shutdown handling.
* Isolate resource leak by implementing graceful disposal in `ParticleCanvas` using `onExit` port.

#### Changed
* Refactored core particle files into `lib/src` directory for better project structure.

## [0.2.0]

#### Added
* Implemented isolate-based animation for improved performance.
* Added a basic test suite for the `AtmosphericParticles` widget.

#### Changed
* Refactored the `ParticleCanvas` to use a long-lived isolate for the animation logic.

## [0.1.0]

#### Added
* Introduced the `FadeDirection` enum (`top`, `bottom`, `left`, `right`, `none`) to control the direction of the particle opacity gradient.

#### Changed
* **Breaking Change:** Replaced the `enableVerticalFade` boolean property with the `fadeDirection` property to allow for more flexible fade effects.

## [0.0.3] 

#### Added
* Added the `repository` field to `pubspec.yaml` to link directly to the GitHub source code.
* Integrated a direct **GitHub link** and documentation link into the `README.md` file.

#### Changed
* Significantly **extended the package `description`** in `pubspec.yaml` to better explain the package's purpose.

## [0.0.2]
* Added an **`example/`** folder containing a working demonstration.


## [0.0.1]

* **Initial Release!**
* Added `AtmosphericParticles` widget to easily add a particle effect background to any widget.
* Added `ParticleCanvas` for managing particle state and animation loop.
* Added `ParticlePainter` for custom painting particles onto the canvas.
* Added customization for:
    * `particleColor`
    * `particleCount`
    * `particleRadius`
    * `minHorizontalVelocity` / `maxHorizontalVelocity`
    * `minVerticalVelocity` / `maxVerticalVelocity`
* Added `enableVerticalFade` option for a vertical "fade-in" opacity gradient.