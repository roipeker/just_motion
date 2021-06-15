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
