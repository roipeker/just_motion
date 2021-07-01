import 'package:flutter/material.dart';
import 'package:just_motion/just_motion.dart';

class HeightWidget extends StatelessWidget {
  const HeightWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = 1.ease(
      target: 88,
      stateless: true,
    );

    return MotionBuilder(
      builder: (context, child) => Container(
        height: height(),
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
