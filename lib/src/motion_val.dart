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

enum MotionState { idle, target, start, deactivate, delayComplete, moving }

abstract class MotionVal<T> with ChangeNotifier, MotionDelay {
  /// used by `Motion` and `MotionBuilder` for the reactive state.
  static _MotionNotifier? proxyNotifier;

  ChangeNotifier? _statusListener;

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
    _statusListener?.notifyListeners();
  }

  late T target, value;

  MotionVal(this.value) : target = value;

  bool get completed => target == value;

  void tick(Duration t);

  @override
  void delay(double seconds) {
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
    cancelDelay();
    _deactivate();
    _statusListener?.dispose();
    target = value;
    if (MotionVal.proxyNotifier != null) {
      MotionVal.proxyNotifier!.remove(this);
    }
    super.dispose();
  }

  void _activate() {
    if (!completed && !isDelayed) {
      _setState(MotionState.start);
      TickerMan.instance.activate(this);
    }
  }

  void _deactivate() {
    _setState(MotionState.deactivate);
    TickerMan.instance.remove(this);
  }

  void set(T val) {
    this.value = this.target = val;
  }

  T call([T? v]) {
    if (v != null) {
      this.target = v;
    }
    return value;
  }

  T to(T target, {double? delay}) {
    this.target = target;
    if (delay != null) {
      this.delay(delay);
    }
    return this.value;
  }

  void _widgetDeactivate() {
    if (!hasListeners) {
      dispose();
    }
  }
}

typedef Widget WidgetBuilderContextless();

class Motion extends StatelessWidget {
  final WidgetBuilderContextless builder;

  const Motion(this.builder, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MotionBuilder(
        builder: (_, __) => builder(),
      );
}

class MotionBuilder extends StatefulWidget {
  final TransitionBuilder builder;
  final Widget? child;

  const MotionBuilder({
    required this.builder,
    this.child,
    Key? key,
  }) : super(key: key);

  @override
  _MotionBuilderState createState() => _MotionBuilderState();
}

class _MotionBuilderState extends State<MotionBuilder> {
  late _MotionNotifier notifier = _MotionNotifier(update);

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  void update() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildWidget(BuildContext context, Widget? child) =>
      widget.builder(context, child);

  Widget notifyChild(BuildContext context, Widget? child) {
    final oldNotifier = MotionVal.proxyNotifier;
    MotionVal.proxyNotifier = notifier;
    final result = _buildWidget(context, child);
    MotionVal.proxyNotifier = oldNotifier;
    return result;
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: notifier.animations,
        builder: (_, child) => notifyChild(context, child),
        child: widget.child,
      );
}

class _MotionNotifier {
  static final emptyListener = ChangeNotifier();

  Listenable animations = emptyListener;
  final VoidCallback stateSetter;
  final _motions = <Listenable>{};

  _MotionNotifier(this.stateSetter);

  void add(MotionVal motion) {
    if (!_motions.contains(motion)) {
      _motions.add(motion);
      _updateCollection();
    }
  }

  void remove(MotionVal motion) {
    if (_motions.contains(motion)) {
      _motions.remove(motion);
      _updateCollection();
    }
  }

  void _updateCollection() {
    if (_motions.isEmpty) {
      animations = emptyListener;
    } else {
      animations = Listenable.merge(_motions.toList(growable: false));
    }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) => stateSetter());
  }

  void dispose() {
    /// stop motions from running.
    _motions.forEach((motion) {
      if (motion is MotionVal) {
        motion._widgetDeactivate();
      }
    });
    animations = emptyListener;
    _motions.clear();
  }
}
