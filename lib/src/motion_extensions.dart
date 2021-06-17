part of just_motion;

extension MotionRectExtension on Rect {
  /// extension method for [EaseRect] (`<Rect>`).
  EaseRect ease({
    Rect? target,
    double minDistance = 0.01,
    double ease = 0.1,
  }) =>
      EaseRect(
        this,
        target: target,
        minDistance: minDistance,
        ease: ease,
      );
}

extension MotionBoxConstraintsExtension on BoxConstraints {
  /// extension method for [EaseBoxConstraints] (`<BoxConstraints>`).
  EaseBoxConstraints ease({
    BoxConstraints? target,
    double minDistance = 0.01,
    double ease = 0.1,
  }) =>
      EaseBoxConstraints(
        this,
        target: target,
        minDistance: minDistance,
        ease: ease,
      );
}

extension MotionInsetsExtension on EdgeInsets {
  /// extension method for [EaseInsets] (`<EdgeInsets>`).
  EaseInsets ease({
    EdgeInsets? target,
    double minDistance = 0.01,
    double ease = 0.1,
  }) =>
      EaseInsets(
        this,
        target: target,
        minDistance: minDistance,
        ease: ease,
      );
}

extension MotionAlignmentExtension on Alignment {
  /// extension method for [EaseAlignment] (`<Alignment>`).
  EaseAlignment ease({
    Alignment? target,
    double minDistance = 0.01,
    double ease = 0.1,
  }) =>
      EaseAlignment(
        this,
        target: target,
        minDistance: minDistance,
        ease: ease,
      );
}

extension MotionOffsetExtension on Offset {
  /// extension method for [EaseOffset] (`<Offset>`).
  EaseOffset ease({
    Offset? target,
    double minDistance = 0.01,
    double ease = 0.1,
  }) =>
      EaseOffset(
        this,
        target: target,
        minDistance: minDistance,
        ease: ease,
      );
}

extension MotionColorExtension on Color {
  /// extension method for [EaseColor] (`<Color>`).
  EaseColor ease({
    Color? target,
    double minDistance = 4,
    double ease = 0.05,
  }) =>
      EaseColor(
        this,
        target: target,
        minDistance: minDistance,
        ease: ease,
      );
}

extension MotionDoubleExtension on num {
  /// extension method for [EaseValue] (`<num>` but outputs `double`).
  EaseValue ease({
    num? target,
    double minDistance = 0.1,
    double ease = 0.1,
  }) =>
      EaseValue(
        this.toDouble(),
        target: target?.toDouble(),
        minDistance: minDistance,
        ease: ease,
      );

  /// extension method for [SpringValue] (`<num>` but outputs `double`).
  SpringValue spring({
    num? target,
    double minDistance = 0.05,
    double spring = 0.1,
    double friction = 0.95,
  }) =>
      SpringValue(
        this.toDouble(),
        target: target?.toDouble(),
        minDistance: minDistance,
        friction: friction,
        spring: spring,
      );
}
