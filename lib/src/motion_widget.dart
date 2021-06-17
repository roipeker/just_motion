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
    notifier.dispose();
    super.dispose();
  }

  void update() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget notifyChild(BuildContext context, Widget? child) {
    final oldNotifier = MotionValue.proxyNotifier;
    MotionValue.proxyNotifier = notifier;
    final result = widget.builder(context, child);
    MotionValue.proxyNotifier = oldNotifier;
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

  void add(MotionValue motion) {
    if (!_motions.contains(motion)) {
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

  void dispose() {
    /// stop motions from running.
    _motions.forEach((motion) {
      if (motion is MotionValue) {
        motion._widgetDeactivate();
      }
    });
    animations = emptyListener;
    _motions.clear();
  }
}
