part of just_motion;

/// [TickerMan] sits at the core of **just_motion**, and manages the single
/// [Ticker] that runs all `MotionValue` simulations.
/// Detects when a [MotionValue] subscribes (meaning the `value!=target`)
/// and starts the ticker if not running; when all
/// motions are completed, the ticker stops.
///
/// [TickerMan] shouldn't be commonly used externally by the developer.
/// as it manages the state internally with [MotionValue].
class TickerMan {
  static TickerMan _instance = TickerMan();

  static TickerMan get instance => _instance;

  late Ticker _ticker = Ticker(_onTick);
  final _motions = <MotionValue>{};

  Set<MotionValue> get motions => _motions;
  void isActive() => _ticker.isActive;

  /// Stops the the `Ticker` provider
  void stop() {
    if (_ticker.isActive) _ticker.stop();
  }

  /// Starts the the `Ticker` provider
  void start() {
    if (!_ticker.isActive) _ticker.start();
  }

  /// callback that runs the simulation on any active [MotionValue].
  void _onTick(Duration t) {
    final remover = <MotionValue>{};
    final _safeMotions = Set.of(_motions);
    _safeMotions.forEach((motion) {
      motion.tick(t);
      if (motion.completed) {
        remover.add(motion);
      }
    });
    remover.forEach((motion) {
      _motions.remove(motion);
    });
    if (_motions.isEmpty) {
      stop();
    }
  }

  /// Removes a [MotionValue] object from the ticking.
  void remove<T>(MotionValue<T> motion) {
    _motions.remove(motion);
  }

  /// Activates a [MotionValue] object and adds it to the ticking queue.
  void activate<T>(MotionValue<T> motion) {
    if (!motion.completed) {
      _motions.add(motion);
      start();
    }
  }
}
