import 'package:flutter/material.dart';
import 'package:just_motion/just_motion.dart';

class OpacityWidget extends StatelessWidget {
  const OpacityWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final opacity = .01.ease(
      target: 1,
      ease: .05,
      minDistance: .01,
      stateless: true,
    );
    opacity.delay(Duration(milliseconds: 200));
    return MotionBuilder(
      builder: (context, child) => Opacity(
        child: child,
        opacity: opacity(),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: const [
            BoxShadow(
              offset: Offset.zero,
              color: Colors.grey,
              blurRadius: 6,
            )
          ],
        ),
        child: Text(
          '$this',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
