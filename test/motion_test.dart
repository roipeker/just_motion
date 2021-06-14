import 'package:flutter_test/flutter_test.dart';

import 'package:just_motion/just_motion.dart';

void main() {
  test('adds one to input values', () {
    final height = EulerVal(5);
    height.ease = 20;
    height.target = 40;
    height.tick(Duration.zero);

    expect(height.value, (40 - 5) / 20);
    // final calculator = Calculator();
    // expect(calculator.addOne(2), 3);
    // expect(calculator.addOne(-7), -6);
    // expect(calculator.addOne(0), 1);
  });
}
