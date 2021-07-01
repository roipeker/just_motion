import 'package:flutter/material.dart';
import 'package:just_motion/just_motion.dart';

class SimpleButton extends StatelessWidget {
  const SimpleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final active = const Color(0xff8870ff);
    final hover = const Color(0xff6451cc);

    final padd1 = const EdgeInsets.all(16);
    final padd2 = const EdgeInsets.all(12);

    /// Always pass `stateless=true` when using inside build().
    /// But is ALWAYS preferable to use StatefulWidget and dispose each `MotionValue`.
    final textColor = Colors.white.ease(ease: 1 / 6, stateless: true);
    final borderColor = active.ease(stateless: true);
    final color = active.ease(stateless: true);
    final borderSize = 1.ease(stateless: true, ease: 1 / 14, minDistance: .01);
    final padding = padd1.ease(stateless: true);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onExit: (e) {
        borderColor.to(active, ease: 1 / 18);
        color.to(active, ease: 1 / 18);
      },
      onEnter: (e) {
        borderColor.to(hover, ease: 1 / 10);
        color.to(hover, ease: 1 / 10);
      },
      child: GestureDetector(
        onTapDown: (e) {
          color.to(Colors.transparent, ease: 1 / 4);
          borderSize.to(3, delay: Duration(milliseconds: 200));
          padding.to(padd2, ease: 1 / 4);
          textColor.to(hover);
        },
        onTapUp: (e) {
          borderSize(1);
          color.to(hover, ease: 1 / 8);
          padding.to(padd1, ease: 1 / 12);
          textColor.to(Colors.white);
        },
        child: Motion(
          () => Container(
            padding: padding(),
            decoration: BoxDecoration(
              color: color(),
              border: Border.all(color: borderColor(), width: borderSize()),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Simple button here',
              style: TextStyle(color: textColor()),
            ),
          ),
        ),
      ),
    );
  }
}
