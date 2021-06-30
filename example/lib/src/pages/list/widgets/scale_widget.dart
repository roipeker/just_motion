import 'package:flutter/material.dart';
import 'package:just_motion/just_motion.dart';

class ScaleWidget extends StatelessWidget {
  const ScaleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale = .1.ease(
      target: 1,
    );
    return MotionBuilder(
      builder: (context, child) => Transform.scale(
        scale: scale(),
        child: child,
        origin: Offset(-300, 0),
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
