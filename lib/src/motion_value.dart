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

enum MotionStatus {
  idle,
  target,
  activate,
  deactivate,
  delayComplete,
  moving,
  disposed
}

abstract class MotionValue<T> with ChangeNotifier, MotionDelay {
  /// MotionValues that will only be consumed as computational for other
  /// values.
  /// Check [EaseColor]
  bool _dumb = false;

  /// used by `Motion` and `MotionBuilder` for the reactive state.
  static _MotionNotifier? _proxyNotifier;

  ChangeNotifier? _statusListener;

  /// disposes this instance when [Motion] or [MotionBuilder] reassembles.
  /// Set it to true when defining this var inside a `build(BuildContext)` scope.
  bool stateless = false;

  @override
  String toString() {
    final statusString = '$status'.split('.')[1];
    return '$runtimeType#$hashCode, status=$statusString, value=$value, target=$target';
  }

  void removeStatusListener(VoidCallback listener) {
    _statusListener?.removeListener(listener);
  }

  void addStatusListener(VoidCallback listener) {
    _statusListener ??= ChangeNotifier();
    _statusListener!.addListener(listener);
  }

  late MotionStatus _status = MotionStatus.idle;

  MotionStatus get status => _status;

  /// shorthand to set the [MotionStatus], and avoid duplicated notifications.
  /// Prevent duplicates doesn't apply to [MotionStatus.moving].
  void _setStatus(MotionStatus val) {
    if (_status == val && val != MotionStatus.moving) return;
    _status = val;
    if (_statusListener != null) {
      /// This is for pending testing,
      /// If _notify_ throws, check the commented code below with
      /// microtask.
      _statusListener?.notifyListeners();

      /// No next frame will be available.
      // if (val == MotionStatus.disposed) {
      //   _statusListener?.notifyListeners();
      // } else {
      //   // Future.microtask(() => _statusListener?.notifyListeners());
      // }
    }
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
    _setStatus(MotionStatus.delayComplete);
    if (!completed) {
      _activate();
    }
  }

  @override
  void dispose() {
    _setStatus(MotionStatus.disposed);
    cancelDelay();
    TickerMan.instance.remove(this);
    if (MotionValue._proxyNotifier != null) {
      MotionValue._proxyNotifier!.remove(this);
    }
    _statusListener?.dispose();
    _statusListener = null;
    super.dispose();
  }

  void _activate() {
    if (_dumb) return;
    if (!completed && !isDelayed) {
      _setStatus(MotionStatus.activate);
      TickerMan.instance.activate(this);
    }
  }

  void _deactivate() {
    if (_dumb) return;
    _setStatus(MotionStatus.deactivate);
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

  /// If using [Motion] or [MotionBuilder] Widget, when _reassembling_
  /// (hot reload) if this instance is flagged to be "created" in a Stateless
  /// widget (with `stateless=true`), dispose the instance to unregister from [TickerMan].
  void _widgetDeactivate(bool reassembling) {
    if (!hasListeners || (reassembling && stateless)) {
      dispose();
    }
  }
}
