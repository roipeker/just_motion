part of just_motion;

typedef Widget MotionCallback();

/// Reactively calls the [builder] callback, detecting [MotionValue] references
/// inside it's scope.
/// Unlike [MotionBuilder] doesn't cache a `child`, nor pass the `context` to the
/// `builder` callback.
/// Might be used on 'leaf' widgets.
class Motion extends StatelessWidget {
  final MotionCallback builder;

  const Motion(this.builder, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MotionBuilder(
        builder: (_, __) => builder(),
        key: key,
      );
}

/// Reactively calls [builder], detecting [MotionValue] references
/// inside it's scope.
/// Accepts a [child] parameter to optimize the rendering.
/// [MotionBuilder] can be used as a reactive alternative to
/// [AnimatedBuilder]
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
    notifier.dispose(false);
    super.dispose();
  }

  @override
  void reassemble() {
    notifier.dispose(true);
    super.reassemble();
  }

  /// Will dispose() current running instances when the Widget rebuilds
  /// This is an uncommon approach, as you should not initialize [MotionValue]
  /// in a Widget `build()`. But it helps to prevent memory leaks with orphan
  /// objects owned by the [_MotionNotifier] and [TickerMan].
  @override
  void didUpdateWidget(MotionBuilder oldWidget) {
    notifier._dirtyWidget = true;
    super.didUpdateWidget(oldWidget);
  }

  void update() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget notifyChild(BuildContext context, Widget? child) {
    final oldNotifier = MotionValue._proxyNotifier;
    MotionValue._proxyNotifier = notifier;
    if (notifier._dirtyWidget) {
      notifier.dirtyWidgetPrebuild();
    }
    final result = widget.builder(context, child);
    notifier._dirtyWidget = false;
    MotionValue._proxyNotifier = oldNotifier;
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
  final Set<MotionValue> _motions = <MotionValue>{};
  Set<MotionValue>? _cachedMotions;

  bool _dirtyWidget = false;

  _MotionNotifier(this.stateSetter);

  void dirtyWidgetPrebuild() {
    _cachedMotions = Set.from(_motions);
  }

  void add(MotionValue motion) {
    if (!_motions.contains(motion)) {
      if (_cachedMotions != null &&
          _dirtyWidget &&
          _cachedMotions!.isNotEmpty) {
        final _cached = _cachedMotions!;
        for (var m in _cached) {
          m.dispose();
        }
        _motions.removeAll(_cached);
        _cached.clear();
        _cachedMotions = null;
      }
      _motions.add(motion);
      _updateCollection();
    }
  }

  void remove(MotionValue motion) {
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

  /// Clears the instance data.
  /// Optionally pass `reassembling=true` to force the motions disposing
  /// (usually useful for hot-reload).
  void dispose([bool reassembling = false]) {
    /// stop motions from running.
    final _buffer = List.of(_motions);
    _buffer.forEach((motion) {
      if (motion is MotionValue) {
        motion._widgetDeactivate(reassembling);
      }
    });
    animations = emptyListener;
    _motions.clear();
    _buffer.clear();
    _cachedMotions?.clear();
    _cachedMotions = null;
  }
}
