## 0.0.6+24
- improve readme.

## 0.0.6+23
- improve docs and readme.

## 0.0.6+22
- renamed `MotionState` to `MotionStatus`, to keep it idiomatic with Flutter's `AnimationController`.
- renamed `motion.state` to `motion.status`.
- added `MotionState.disposed` notification.
- fix notifications for `MotionState.moving`
- improved `toString()` on `Ease` and `Spring` motion variants, to describe better the motion instance.
- removed the "microtask delay" for new states notifications with `statusListener`.
- added missing hot-reload support code.
- EXPERIMENTAL: added instance auto de-registration for `MotionValue` instances created inside `build(BuildContext)`, this is
  still experimental, and still have to be tested in multiple use-cases of motion, to see if it brings collateral issues. 
- add some code docs.

## 0.0.5+15
- `MotionValue` forced to dispose on `reassembling` (hot-reload).
- add some code docs.

## 0.0.4+12
- add some code docs.
- add `EaseRect`, `EaseBoxConstraints`, `EaseInsets` with their extensions .
- add `EaseBase._easeValue()` to facilitate easing in complex types.
- add build number to version, to avoid modifying min version for docs and readme changes.
- add `flutter_lints` package for analysis.

## 0.0.3
- fix for EaseColor using a "_dumb" flag to avoid expensive notifications.
- fix default values for `EaseColor`
- fix MotionTicker, to avoid removing MotionValues while looping.
- changed some `MotionStates` (can be detected with `addStatusListener()` and using the `state` property.).

## 0.0.2
- cleanup.
- includes `SpringValue`
- added support for `timeDilation` (Flutter's slow motion.)
- renamed `EulerValue` to `EaseValue`.
- renamed extension `obj.euler()` to `obj.ease()`
- `ease()` will accept `num` (int or double) for value/target, but treats all as `double`. Make sure to convert double to int if you consume it that way (`round()`, `ceil()`, `floor()`, `toInt()`, etc).

## 0.0.1

- basic initial alpha release.
`MotionValue` API will likely change.
