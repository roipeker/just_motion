part of just_motion;

/// Base class for `Springs`.
abstract class SpringBase<T> extends MotionValue<T> with CommonBaseMotion {
  /// Spring factor..
  double spring = 0.1;

  /// `friction` helps the `value` to settle down on target, as acceleration
  /// gets reduced.
  double friction = .95;

  /// defines the *stop distance* between target and value..
  /// When `(target-value).abs() <= minDistance` evaluates true, the
  /// `value` becomes the `target`, and the motion state is completed,
  /// so it gets removed from the Ticker.
  double minDistance = .05;

  /// internal velocity change tracking.
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

  /// Shortcut method to configure common `SpringValue` properties.
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

/// A concrete implementation of the base Spring, based on `double`.
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

  /// Computes the current Spring frame.
  /// This method is called by `TickerMan` to all `MotionValue`.
  /// [t] is not used for now.
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
  /// Ensures the [target] has a new value.
  /// auto activates() this instance with the Ticker.
  /// and notify subclasses to update target related properties,
  /// like `ColorEase()`.
  @override
  set target(T v) {
    if (target == v) return;
    super.target = v;
    _updateTarget();
    _activate();
  }

  /// returns the [`value`], while proxying the instance into
  /// a `MotionBuilder()` to notify the existance in the scope.
  @override
  T get value {
    if (MotionValue.proxyNotifier != null) {
      MotionValue.proxyNotifier!.add(this);
    }
    return super.value;
  }

  /// sets a new [value] and notifies any listeners about the [value] change
  /// in this Listenable.
  /// also notifying subclasses the update.
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

  /// Must be overwritten in custom subclasses
  void _updateValue() {}
}
