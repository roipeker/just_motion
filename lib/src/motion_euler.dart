part of just_motion;

abstract class EulerBase<T> extends MotionVal<T> {
  late double minDistance, ease;

  @override
  String toString() {
    return '$value / $target';
  }

  EulerBase(
    T value, {
    T? target,
    double minDistance = .01,
    double ease = 10,
  }) : super(value) {
    this.minDistance = minDistance;
    this.ease = ease;
    this.target = target ?? value;
  }

  /// todo: should it have accessor (get/set)
  /// on MotionVal?
  @override
  set target(T v) {
    if (target == v) return;
    super.target = v;
    _updateTarget();
    _activate();
  }

  @override
  T get value {
    if (MotionVal.proxyNotifier != null) {
      MotionVal.proxyNotifier!.add(this);
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

  @override
  T to(
    T target, {
    double? delay,
    double? minDistance,
    double? ease,
  }) {
    this.target = target;
    if (delay != null) this.delay(delay);
    if (minDistance != null) this.minDistance = minDistance;
    if (ease != null) this.ease = ease;
    return this.value;
  }

  /// Must be overwritten in custom subclasses
  /// like `EulerColor`.
  void _updateTarget() {}

  void _updateValue() {}
}

class EulerVal extends EulerBase<double> {
  EulerVal(
    double value, {
    double? target,
    double minDistance = .1,
    double ease = 10,
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
      _setState(MotionState.target);
    } else {
      value += distance / ease;
      _setState(MotionState.moving);
    }
  }
}

class EulerInt extends EulerBase<int> {
  final EulerVal _value;

  EulerInt(
    int value, {
    int? target,
    double minDistance = .1,
    double ease = 10,
  })  : _value = EulerVal(
          value + .0,
          target: target?.toDouble(),
          minDistance: minDistance,
          ease: ease,
        ),
        super(
          value,
          target: target,
          minDistance: minDistance,
          ease: ease,
        );

  @override
  void _updateTarget() {
    _value(target + .0);
  }

  @override
  void _updateValue() {
    _value.value = value + .0;
  }

  @override
  bool get completed => _value.completed;

  @override
  double get ease => _value.ease;

  @override
  set ease(double v) => _value.ease = v;

  @override
  double get minDistance => _value.minDistance;

  @override
  set minDistance(double v) => _value.minDistance = v;

  @override
  int get value => _value().round();

  @override
  void tick(Duration t) {
    if (isDelayed) return;
    if (!_value.completed) {
      _value.tick(t);
    }
    if (_value.completed) {
      value = target;
      notifyListeners();
    } else {
      notifyListeners();
    }
  }
}

class EulerAlignment extends EulerBase<Alignment> {
  EulerAlignment(
    Alignment value, {
    Alignment? target,
    double minDistance = .1,
    double ease = 10,
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
      value += distance / ease;
    }
  }
}

class EulerOffset extends EulerBase<Offset> {
  EulerOffset(
    Offset value, {
    Offset? target,
    double minDistance = .1,
    double ease = 10,
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
      value += distance / ease;
    }
  }
}

class EulerColor extends EulerBase<Color> {
  final r = EulerVal(0), g = EulerVal(0), b = EulerVal(0), a = EulerVal(0);

  EulerColor(
    Color value, {
    Color? target,
    double minDistance = 2,
    double ease = 20,
  }) : super(
          value,
          target: target,
          minDistance: minDistance,
          ease: ease,
        ) {
    /// check the hack.
    super.value = const Color(0x0);
    super.value = value;
  }

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
  bool get completed => value.value == target.value;

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
  Color get value =>
      Color.fromARGB(a().round(), r().round(), g().round(), b().round());

  @override
  void tick(Duration t) {
    if (isDelayed) return;
    if (!r.completed) r.tick(t);
    if (!g.completed) g.tick(t);
    if (!b.completed) b.tick(t);
    if (!a.completed) a.tick(t);
    if (r.completed && g.completed && b.completed && a.completed) {
      value = target;
    } else {
      notifyListeners();
    }
  }
}
