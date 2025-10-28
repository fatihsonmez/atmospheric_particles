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