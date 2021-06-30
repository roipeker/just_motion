import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:just_motion/just_motion.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  /// as we work with 0-1 values, we need a small `minDistance` to prevent abrupt
  /// jumps.
  final _expandAnimation = 0.ease(minDistance: .01);
  final _opacity = 1.0.ease(minDistance: .01, ease: 1 / 12);
  final _scale = 1.0.ease(minDistance: .01, ease: 1 / 4);

  bool _open = false;

  @override
  void dispose() {
    _expandAnimation.dispose();
    _opacity.dispose();
    _opacity.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
  }

  void _toggle() {
    setState(() => _open = !_open);
    _expandAnimation(_open ? 1 : 0);
    _scale(_open ? 0.7 : 1);
    _opacity(_open ? 0 : 1);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: Motion(() {
        return Transform.scale(
          scale: _scale(),
          child: Opacity(
            opacity: _opacity(),
            child: FloatingActionButton(
              onPressed: _toggle,
              child: const Icon(Icons.create),
            ),
          ),
        );
      }),
    );
  }
}

class _ExpandingActionButton extends StatelessWidget {
  _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final EaseValue progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Motion(
      () {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: Opacity(
              opacity: progress(),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
