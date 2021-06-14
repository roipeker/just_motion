part of just_motion;

extension MotionAlignmentExtension on Alignment {
  EulerAlignment euler({
    Alignment? target,
    double minDistance = .01,
    double ease = 10,
  }) =>
      EulerAlignment(
        this,
        target: target,
        minDistance: minDistance,
        ease: ease,
      );
}

extension MotionOffsetExtension on Offset {
  EulerOffset euler({
    Offset? target,
    double minDistance = .01,
    double ease = 10,
  }) =>
      EulerOffset(
        this,
        target: target,
        minDistance: minDistance,
        ease: ease,
      );
}

extension MotionColorExtension on Color {
  EulerColor euler({
    Color? target,
    double minDistance = .01,
    double ease = 20,
  }) =>
      EulerColor(
        this,
        target: target,
        minDistance: minDistance,
        ease: ease,
      );
}

extension MotionDoubleExtension on double {
  EulerVal euler({
    num? target,
    double minDistance = .1,
    double ease = 20,
  }) =>
      EulerVal(
        this.toDouble(),
        target: target?.toDouble(),
        minDistance: minDistance,
        ease: ease,
      );
}

extension MotionIntExtension on int {
  EulerInt euler({
    int? target,
    double minDistance = .1,
    double ease = 20,
  }) =>
      EulerInt(
        this,
        target: target,
        minDistance: minDistance,
        ease: ease,
      );
}
