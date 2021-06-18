part of just_motion;

mixin MotionDelay {
  Timer? _delay;

  bool get isDelayed => _delay?.isActive ?? false;

  void cancelDelay() {
    _delay?.cancel();
    _delay = null;
  }

  void delay(double seconds) {
    cancelDelay();
    _delay = Timer(
      Duration(milliseconds: (seconds * 1000).round()),
      onDelayComplete,
    );
  }

  void onDelayComplete() {
    cancelDelay();
  }

  void dispose() {
    cancelDelay();
  }
}

enum MotionState { idle, target, activate, deactivate, delayComplete, moving }

abstract class MotionValue<T> with ChangeNotifier, MotionDelay {
  /// MotionValues that will only be consumed as computational for other
  /// values.
  /// Check [EaseColor]
  bool _dumb = false;

  /// used by `Motion` and `MotionBuilder` for the reactive state.
  static _MotionNotifier? proxyNotifier;

  ChangeNotifier? _statusListener;

  @override
  String toString() {
    return '$value / $target';
  }

  void removeStatusListener(VoidCallback listener) {
    _statusListener?.removeListener(listener);
  }

  void addStatusListener(VoidCallback listener) {
    _statusListener ??= ChangeNotifier();
    _statusListener!.addListener(listener);
  }

  late MotionState _state = MotionState.idle;
  MotionState get state => _state;
  void _setState(MotionState val) {
    if (_state == val) return;
    _state = val;
    if (_statusListener != null) {
      Future.microtask(() => _statusListener?.notifyListeners());
    }
    // _statusListener?.notifyListeners();
  }

  late T target, value;

  MotionValue(this.value) : target = value;

  bool get completed => target == value;

  /// time dilation factor.
  double get _dt => 1 / timeDilation;

  void tick(Duration t);

  @override
  void delay(double seconds) {
    if (_dumb) return;
    if (!completed) _deactivate();
    super.delay(seconds);
  }

  @override
  void onDelayComplete() {
    super.onDelayComplete();
    _setState(MotionState.delayComplete);
    if (!completed) {
      _activate();
    }
  }

  @override
  void dispose() {
    // target = value;
    cancelDelay();
    TickerMan.instance.remove(this);
    if (MotionValue.proxyNotifier != null) {
      MotionValue.proxyNotifier!.remove(this);
    }
    _statusListener?.dispose();
    super.dispose();
  }

  void _activate() {
    if (_dumb) return;
    if (!completed && !isDelayed) {
      _setState(MotionState.activate);
      TickerMan.instance.activate(this);
    }
  }

  void _deactivate() {
    if (_dumb) return;
    _setState(MotionState.deactivate);
    TickerMan.instance.remove(this);
  }

  void set(T val) {
    this.value = this.target = val;
  }

  /// Callable instance, optionally sets the [target].
  /// Always returns the current [value].
  T call([T? v]) {
    if (v != null) {
      this.target = v;
    }
    return value;
  }

  /// Shortcut to assign the [target], with the ability
  /// of settings the [delay] (in seconds).
  T to(T target, {double? delay}) {
    this.target = target;
    if (delay != null) {
      this.delay(delay);
    }
    return this.value;
  }

  /// If [reassembling] (hot reload) force the
  /// disposal of the instance to unregister from [TickerMan].
  void _widgetDeactivate(bool reassembling) {
    if (!hasListeners || reassembling) {
      dispose();
    }
  }
}
