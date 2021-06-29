part of just_motion;

abstract class EaseBase<T> extends MotionValue<T> {
  late double minDistance, ease;

  EaseBase(
    T value, {
    String? id,
    T? target,
    double minDistance = .01,
    double ease = 0.1,
  })  : assert(ease > 0.0 && ease < 1.0,
            '"ease" has to be > 0 and < 1, think of it as 1 / divisions. For example `ease: 1 / 30`'),
        super(value) {
    this.minDistance = minDistance;
    this.ease = ease;
    this.target = target ?? value;
    _updateValue();
  }

  /// Todo: should it have accessor (get/set) on `MotionValue`?
  @override
  set target(T v) {
    if (target == v) return;
    super.target = v;
    _updateTarget();
    _activate();
  }

  @override
  T get value {
    if (!_dumb && MotionValue._proxyNotifier != null) {
      MotionValue._proxyNotifier!.add(this);
    }
    return super.value;
  }

  @override
  set value(T v) {
    if (super.value == v) return;
    super.value = v;
    _updateValue();
    if (!_dumb) {
      notifyListeners();
    }
    if (v == target) {
      _setStatus(MotionStatus.target);
    } else {
      _setStatus(MotionStatus.moving);
    }
  }

  @override
  T to(
    T target, {
    Duration? delay,
    double? minDistance,
    double? ease,
  }) {
    this.target = target;
    if (delay != null) this.delay(delay);
    if (minDistance != null) this.minDistance = minDistance;
    if (ease != null) this.ease = ease;
    return this.value;
  }

  /// Accessible shortcut to ease individual properties of complex objects.
  /// returns `target` for `minDistance` hit, or invalid values.
  double _easeValue(double value, double target) {
    if (value == target || value.isInfinite || value.isNaN) return target;
    var dx = target - value;
    if (dx.abs() <= minDistance) return target;
    return value + (dx * ease) * _dt;
  }

  /// Must be overwritten in custom subclasses
  /// like `EulerColor`.
  void _updateTarget() {}

  void _updateValue() {}
}

class EaseValue extends EaseBase<double> {
  @override
  String toString() {
    final statusString = '$status'.split('.')[1];
    return '$runtimeType#$hashCode status=$statusString, value=~${value.toStringAsPrecision(2)}, target=${target.toStringAsPrecision(2)}';
  }

  EaseValue(
    double value, {
    double? target,
    double minDistance = 0.1,
    double ease = 0.1,
  }) : super(
          value,
          target: target,
          minDistance: minDistance,
          ease: ease,
        );

  @override
  void tick(Duration t) {
    if (isDelayed) return;
    double distance = target - value;
    if (distance.abs() <= minDistance) {
      value = target;
      // _setState(MotionState.target);
    } else {
      value += (distance * ease) * _dt;
      _setStatus(MotionStatus.moving);
    }
  }
}

class EaseAlignment extends EaseBase<Alignment> {
  EaseAlignment(
    Alignment value, {
    Alignment? target,
    double minDistance = 0.1,
    double ease = 0.1,
  }) : super(
          value,
          target: target,
          minDistance: minDistance,
          ease: ease,
        );

  @override
  void tick(Duration t) {
    Alignment distance = target - value;
    if (distance.x.abs() <= minDistance && distance.y.abs() <= minDistance) {
      value = target;
    } else {
      value += (distance * ease) * _dt;
    }
  }
}

class EaseOffset extends EaseBase<Offset> {
  EaseOffset(
    Offset value, {
    Offset? target,
    double minDistance = 0.1,
    double ease = 0.1,
  }) : super(
          value,
          target: target,
          minDistance: minDistance,
          ease: ease,
        );

  @override
  void tick(Duration t) {
    Offset distance = target - value;
    if (distance.dx.abs() <= minDistance && distance.dy.abs() <= minDistance) {
      value = target;
    } else {
      value += (distance * ease) * _dt;
    }
  }
}

class EaseRect extends EaseBase<Rect> {
  EaseRect(
    Rect value, {
    Rect? target,
    double minDistance = 0.1,
    double ease = 0.1,
  }) : super(
          value,
          target: target,
          minDistance: minDistance,
          ease: ease,
        );

  @override
  void tick(Duration t) {
    final _temp = Rect.fromLTRB(
      _easeValue(value.left, target.left),
      _easeValue(value.top, target.top),
      _easeValue(value.right, target.right),
      _easeValue(value.top, target.bottom),
    );
    if (_temp == target) {
      value = target;
    } else {
      value = _temp;
    }
  }
}

/// Generates an ease transition between BoxConstraints.
/// When an invalid transition value (double), like `NaN` or `infinite`,
/// is used on [BoxConstraints.minWidth], [BoxConstraints.minHeight],
/// [BoxConstraints.maxWidth] or [BoxConstraints.maxHeight], the
/// [EaseBoxConstraints.value] property will be set to [EaseBoxConstraints.target] one.
class EaseBoxConstraints extends EaseBase<BoxConstraints> {
  EaseBoxConstraints(
    BoxConstraints value, {
    BoxConstraints? target,
    double minDistance = 0.1,
    double ease = 0.1,
  }) : super(
          value,
          target: target,
          minDistance: minDistance,
          ease: ease,
        );

  @override
  void tick(Duration t) {
    final _temp = value.copyWith(
      minWidth: _easeValue(value.minWidth, target.minWidth),
      minHeight: _easeValue(value.minHeight, target.minHeight),
      maxWidth: _easeValue(value.maxWidth, target.maxWidth),
      maxHeight: _easeValue(value.maxHeight, target.maxHeight),
    );
    if (_temp == target) {
      value = target;
    } else {
      value = _temp;
    }
  }
}

class EaseInsets extends EaseBase<EdgeInsets> {
  EaseInsets(
    EdgeInsets value, {
    EdgeInsets? target,
    double minDistance = 0.1,
    double ease = 0.1,
  }) : super(
          value,
          target: target,
          minDistance: minDistance,
          ease: ease,
        );

  @override
  void tick(Duration t) {
    final distance = target - value;
    if (distance.left.abs() <= minDistance &&
        distance.right.abs() <= minDistance &&
        distance.top.abs() <= minDistance &&
        distance.bottom.abs() <= minDistance) {
      value = target;
    } else {
      value += (distance * ease) * _dt;
    }
  }
}

class EaseColor extends EaseBase<Color> {
  final r = EaseValue(0).._dumb = true,
      g = EaseValue(0).._dumb = true,
      b = EaseValue(0).._dumb = true,
      a = EaseValue(0).._dumb = true;

  EaseColor(
    Color value, {
    Color? target,
    double minDistance = 4,
    double ease = 0.05,
  }) : super(
          value,
          target: target,
          minDistance: minDistance,
          ease: ease,
        );

  void channelEase({double? r, double? g, double? b, double? a}) {
    if (r != null) this.r.ease = r;
    if (g != null) this.g.ease = g;
    if (b != null) this.b.ease = b;
    if (a != null) this.a.ease = a;
  }

  @override
  double get ease => r.ease;

  @override
  set ease(double v) => r.ease = g.ease = b.ease = a.ease = v;

  @override
  double get minDistance => r.minDistance;

  @override
  set minDistance(double v) =>
      r.minDistance = g.minDistance = b.minDistance = a.minDistance = v;

  @override
  bool get completed =>
      r.completed && g.completed && b.completed && a.completed;

  @override
  void _updateTarget() {
    r(target.red + .0);
    g(target.green + .0);
    b(target.blue + .0);
    a(target.alpha + .0);
  }

  @override
  void _updateValue() {
    r.value = super.value.red + .0;
    g.value = super.value.green + .0;
    b.value = super.value.blue + .0;
    a.value = super.value.alpha + .0;
  }

  @override
  Color get value {
    if (MotionValue._proxyNotifier != null) {
      MotionValue._proxyNotifier!.add(this);
    }
    return Color.fromARGB(a().round(), r().round(), g().round(), b().round());
  }

  @override
  void tick(Duration t) {
    if (isDelayed) return;
    if (!r.completed) r.tick(t);
    if (!g.completed) g.tick(t);
    if (!b.completed) b.tick(t);
    if (!a.completed) a.tick(t);
    if (r.completed && g.completed && b.completed && a.completed) {
      value = target;
      _setStatus(MotionStatus.target);
    } else {
      notifyListeners();
      _setStatus(MotionStatus.moving);
    }
  }

  @override
  void dispose() {
    r.dispose();
    g.dispose();
    b.dispose();
    a.dispose();
    super.dispose();
  }
}
