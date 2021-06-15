part of just_motion;

extension MotionAlignmentExtension on Alignment {
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
