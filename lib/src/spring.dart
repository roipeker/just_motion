part of just_motion;

abstract class SpringBase<T> extends MotionValue<T> with CommonBaseMotion {
  double spring = 0.1;
  double friction = .95;
  double minDistance = .05;
  double _velocity = 0.0;

  SpringBase(
    T value, {
    T? target,
    this.spring = 0.1,
    this.friction = 0.95,
    this.minDistance = 0.05,
  })  : assert(friction > 0.001 && friction < 1.0,
            '"friction" should be > 0 and < 1 to avoid invalid simulations.'),
        super(value) {
    this.target = target ?? value;
  }

  // @override
  // void tick(Duration t)

  @override
  T to(
    T target, {
    double? delay,
    double? minDistance,
    double? spring,
    double? friction,
  }) {
    this.target = target;
    if (delay != null) this.delay(delay);
    if (minDistance != null) this.minDistance = minDistance;
    if (spring != null) this.spring = spring;
    if (friction != null) this.friction = friction;
    return this.value;
  }
}

class SpringValue extends SpringBase<double> with CommonBaseMotion {
  SpringValue(
    double value, {
    double? target,
    double spring = 0.1,
    double friction = 0.95,
    double minDistance = 0.05,
  }) : super(
          value,
          target: target,
          friction: friction,
          spring: spring,
          minDistance: minDistance,
        );

  // @override
  // bool get running => _distance.abs() < stopDistance;

  @override
  void tick(Duration t) {
    if (isDelayed) return;
    var distance = target - value;
    if (distance.abs() <= minDistance) {
      value = target;
      _setState(MotionState.target);
    } else {
      var acc = distance * spring;
      _velocity += acc;
      _velocity *= friction;
      value += _velocity * _dt;
      _setState(MotionState.moving);
    }
  }
}

mixin CommonBaseMotion<T> on MotionValue<T> {
  @override
  set target(T v) {
    if (target == v) return;
    super.target = v;
    _updateTarget();
    _activate();
  }

  @override
  T get value {
    if (MotionValue.proxyNotifier != null) {
      MotionValue.proxyNotifier!.add(this);
    }
    return super.value;
  }

  @override
  set value(T v) {
    if (super.value == v) return;
    super.value = v;
    _updateValue();
    notifyListeners();
  }

  /// Must be overwritten in custom subclasses
  /// like `EulerColor`.
  void _updateTarget() {}

  void _updateValue() {}
}
