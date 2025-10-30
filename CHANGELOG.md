## [0.3.3]

#### Fixed
* A bug where the fade effect was not correctly applied to particle trails.
* A bug where the fade effect would jump when particles wrapped around the screen. The fade is now calculated per-segment for a smooth effect.

## [0.3.2]

#### Changed
* **Refactor:** Replaced `AlignmentGeometry` with `Alignment` for the `childAlignment` property to simplify the API and align with Flutter's best practices.

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
