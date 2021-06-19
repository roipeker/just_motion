part of just_motion;

extension MotionRectExtension on Rect {
  /// Extension method for [EaseRect] (`<Rect>`).
  /// For details on [stateless] see [MotionValue.stateless]
  EaseRect ease({
    Rect? target,
    double minDistance = 0.01,
    double ease = 0.1,
    bool stateless = false,
  }) =>
      EaseRect(
        this,
        target: target,
        minDistance: minDistance,
        ease: ease,
      )..stateless = stateless;
}

extension MotionBoxConstraintsExtension on BoxConstraints {
  /// Extension method for [EaseBoxConstraints] (`<BoxConstraints>`).
  /// For details on [stateless] see [MotionValue.stateless]
  EaseBoxConstraints ease({
    BoxConstraints? target,
    double minDistance = 0.01,
    double ease = 0.1,
    bool stateless = false,
  }) =>
      EaseBoxConstraints(
        this,
        target: target,
        minDistance: minDistance,
        ease: ease,
      )..stateless = stateless;
}

extension MotionInsetsExtension on EdgeInsets {
  /// Extension method for [EaseInsets] (`<EdgeInsets>`).
  /// For details on [stateless] see [MotionValue.stateless]
  EaseInsets ease({
    EdgeInsets? target,
    double minDistance = 0.01,
    double ease = 0.1,
    bool stateless = false,
  }) =>
      EaseInsets(
        this,
        target: target,
        minDistance: minDistance,
        ease: ease,
      )..stateless = stateless;
}

extension MotionAlignmentExtension on Alignment {
  /// Extension method for [EaseAlignment] (`<Alignment>`).
  /// For details on [stateless] see [MotionValue.stateless]
  EaseAlignment ease({
    Alignment? target,
    double minDistance = 0.01,
    double ease = 0.1,
    bool stateless = false,
  }) =>
      EaseAlignment(
        this,
        target: target,
        minDistance: minDistance,
        ease: ease,
      )..stateless = stateless;
}

extension MotionOffsetExtension on Offset {
  /// Extension method for [EaseOffset] (`<Offset>`).
  /// For details on [stateless] see [MotionValue.stateless]
  EaseOffset ease({
    Offset? target,
    double minDistance = 0.01,
    double ease = 0.1,
    bool stateless = false,
  }) =>
      EaseOffset(
        this,
        target: target,
        minDistance: minDistance,
        ease: ease,
      )..stateless = stateless;
}

extension MotionColorExtension on Color {
  /// Extension method for [EaseColor] (`<Color>`).
  /// For details on [stateless] see [MotionValue.stateless]
  EaseColor ease({
    Color? target,
    double minDistance = 4,
    double ease = 0.05,
    bool stateless = false,
  }) =>
      EaseColor(
        this,
        target: target,
        minDistance: minDistance,
        ease: ease,
      )..stateless = stateless;
}

extension MotionDoubleExtension on num {
  /// Extension method for [EaseValue] (`<num>` but outputs `double`).
  /// For details on [stateless] see [MotionValue.stateless]
  EaseValue ease({
    num? target,
    double minDistance = 0.1,
    double ease = 0.1,
    bool stateless = false,
  }) =>
      EaseValue(
        this.toDouble(),
        target: target?.toDouble(),
        minDistance: minDistance,
        ease: ease,
      )..stateless = stateless;

  /// Extension method for [SpringValue] (`<num>` but outputs `double`).
  /// For details on [stateless] see [MotionValue.stateless]
  SpringValue spring({
    num? target,
    double minDistance = 0.05,
    double spring = 0.1,
    double friction = 0.95,
    bool stateless = false,
  }) =>
      SpringValue(
        this.toDouble(),
        target: target?.toDouble(),
        minDistance: minDistance,
        friction: friction,
        spring: spring,
      )..stateless = stateless;
}
