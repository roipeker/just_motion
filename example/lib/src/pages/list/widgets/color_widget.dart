import 'package:flutter/material.dart';
import 'package:just_motion/just_motion.dart';

class ColorWidget extends StatelessWidget {
  const ColorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = 24.0.ease(target: 120, ease: .23);
    final bgColor = Colors.green.ease(ease: .05);
    bgColor.to(Colors.red);
    // height.delay(Duration(seconds: 1));
    return AnimatedBuilder(
      animation: Listenable.merge([height, bgColor]),
      builder: (ctx, child) => Container(
        height: height(),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: bgColor(),
          borderRadius: BorderRadius.circular(6.0),
          // boxShadow: const [
          //   BoxShadow(
          //     offset: Offset.zero,
          //     color: Colors.grey,
          //     blurRadius: 6,
          //   )
          // ],
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
