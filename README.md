# just.motion

Flutter package to create organic motion transitions.

- [Why?](#why?)
- [The Motion Value](#the-motion-value)
- [Ease Motion](#ease-motion)
- [Spring Motion](#spring-motion)
- [The Widgets](#the-widgets)
- [Performance Considerations](#performance-considerations)
- [Installation](#installation)
- [How to contribute](#how-to-contribute)

## Why?

Why not? the basic difference with _Tweens_ is that the change in value looks much cooler, it feels more "organic", while Tweens are more... "mechanical". 

`just.motion` is not based on `Duration` and interpolated percentage values from 0-1; but rather on distance between the current value and the target value. 

On the other hand, it doesn't need a Ticker provider, nor Implicit widgets to compensate the code boilerplate. Also, no need for `AnimationController`.

There's a single internal Ticker, that manages it's own state based on the auto-subscribed `MotionValues`. 
When there're no active motions, it just stops. 

Also, it has a very simple reactive support when `MotionValue`s (base class for `EaseValue` and `SpringValue`) are consumed inside a `Motion()` or `MotionBuilder()` widgets.

Is a great option for your app's animations! as subscriptions and memory management are also automatic when using `MotionValue` with the provided `Motion`(s) widgets.

## The Motion Value

Here's how it works:

Basic _easing_ is a well known technique in games for light computation of movements, is based on proportional velocity, and his cousin, _spring_, is based on proportional acceleration.

You set a `target` value, `MotionValue` calculates the distance, and the movement it applies is proportional to the distance: bigger distance, faster the motion.

So, as _acceleration_ is proportional to the distance, the further the target, the faster the value moves, as it gets closer and closer to the target, it hardly changes the value... that's why you can configure `minDistance` to tell the motion when is time to stop.

While on `springs`, the _acceleration_ is proportional to the distance, if `target` is far away from `value`, a lot of acceleration is provided, increasing the _velocity_ very quickly. Unlike _easing_, as the `value` approaches the `target`, less and less acceleration is applied, but still has an ongoing acceleration, as it flies pass the `target`, the acceleration pulls it back, while `friction` helps the `value` to settle down.

You can listen to motion states changes:

```dart
height.addStatusListener((){
  print(height.state);
});
```
Check `MotionState.values` to see the current avilable states. (Might change in the near future).

### Ease Motion


Declare a var that you will use to animate some widget property:

> NOTE: When using the `ease()` extension, (like `10.ease()`), `int` and `double` nums will use `EaseValue` which is based on `double`.
Is up to you to cast the `value` to `int`: (example:  `height().round()`, or `height().toInt()`).



```dart
final height = EaseValue( 30 );
///or the extension approach.
final height = 30.ease();

final bgColor = EaseColor( Colors.red );
final bgColor = Colors.red.ease();
```
_You can configure the `target` value, and other motion properties right away in both declarations._

To change the `target` value after object initialization:

```dart
/// `MotionValue` is a callable instance. So can change target as if it was a method.
height(100);

/// If you need to change a motion property, you can use:
height.to( 100, ease: 30, minDistance: .1 );

/// or just modify the target property.
height.target = 100;
```

This is what makes **just.motion** shine. You can change the `target` anytime, and it will smoothly transition `value` towards it, without mechanic or abrupt visual cuts, like time based Tweens.

To read the current value:
```dart
print( height());
// or
print( height.value );
```

The motion objects detects when `target` is modified, and runs the simulation accordingly.
A motion object is idle, when `value` reaches `target`, and will be unsubscribed from the ticker provider.

To stop the animation, set the **`motion.value = motion.target`**, otherwise the ticker will keep running until the values are closed enough to hit the `minDistance` threshold, and deactivate themselves.

You can set an absolute value to rebuild the widget, preventing the animation, with:
`height.value = height.target = 10;`

or better yet:
`height.set( 10 );`

## Spring Motion

Much like `EaseValue`, `SpringValue` is another type of motion, just play with the paramters.
Watch out the `minDistance`, probably for drastic bouncing, you will need to provide a very small 
number (like .0001)... use at discretion, and experiment with the values.

```dart
final height = SpringValue(10);

final height = 10.spring()
```

Here's an example of a __bouncing button__.

```dart
class SpringyButton extends StatelessWidget {
  final Widget child;
  final double pressScale;
  SpringyButton({
    Key? key,
    required this.child,
    this.pressScale = 0.75,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaleValue = 1.spring(minDistance: .00025, spring: .1);
    return GestureDetector(
      onTapDown: (e) => scaleValue.to(pressScale, friction: .85),
      onTapUp: (e) => scaleValue.to(1, friction: .92),
      onTapCancel: () => scaleValue.to(1, friction: .92),
      child: MotionBuilder(
        builder: (BuildContext context, Widget? child) => Transform.scale(
          transformHitTests: false,
          scale: scaleValue(),
          child: child,
        ),
        child: child,
      ),
    );
  }
}
```

## The Widgets

`MotionValue` is a ChangeNotifier, so you can use `AnimationBuilder`:


```dart
@override
  Widget build(BuildContext context) {
    final height = 24.0.ease(target: 120, ease: 23);
    final bgColor = Colors.black12.ease(ease: 45);
    bgColor.to(Colors.red);

    /// delay() is defined in seconds, will deactivate the ticker call until it hits the timeout. 
    height.delay(1);

    return Center(
      child: Material(
        child: AnimatedBuilder(
          animation: Listenable.merge([height, bgColor]),
          builder: (context, child) {
            return Container(
              height: height(),
              color: bgColor(),
              child: Center(
                child: Text('height: ${height().toStringAsFixed(2)}'),
              ),
            );
          },
        ),
      ),
    );
  }
```

But motion provides a simpler Widget to repaint your animation.

If you just need to paint a "leaf" widget, so have no need to use the `child` optimization of `AnimatedBuilder`, nor `context`, you can't got simpler than `Motion`:

```dart
return Motion(
  () => Container(
    height: height(),
    color: bgColor(),
    child: Center(
      child: Text('height: ${height().ringAsFixed(2)}'),
    ),
  ),
);
```

When you need to cache the `child` rebuild, like `AnimatedBuilder`, you can use `MotionBuilder`:

```dart
return MotionBuilder(
  builder: (context, child) => Container(
    height: height(),
    color: bgColor(),
    child: Center(
      child: child,
    ),
  ),
  child: Text('animating height'),
);
```

Both widgets will dispose the motion values when they are removed from the widget, if the object isn't consumed by another Listener.

## Performance Considerations

- As there's a single ticker provider running for all `MotionValue` instances, the lifecycle of this Ticker is persistent through the lifetime of your app. Is not tied up to a Widget's `State`, meaning that is totally possible to have lots of concurrent and actives `MotionValue`, even when nothing is consuming those values (you can inspect that in the [_Flutter Performance_ tab in your IDE](https://flutter.dev/docs/perf/rendering/ui-performance)). 
When you initialize a motion object, **and set a target** different than the `value`... the `Ticker` will start processing the object, no matter if you are consuming the value to repaint a Widget or not. This is not a big penalty on performance by any means, as Flutter does it all the time, but be sure to orchestrate properly the `target` assignment, when you actually will consume the value.

- If you are using a `StatefulWidget`, or some other state management solution that provides you with Widget lifecycles, you can manually call `motion.dispose()`. Although memory is managed internally, didn't find any leaks so far.

- If you are composing nested Animations, or reusable Widgets based on **just.motion**, is better to avoid child rebuilds in your tree. Prefer the usage of `MotionBuilder()` for those scenarios. And yes, you can deeply nest motion objects into `Motion()` and `MotionBuilder()` and they will take the appropiate `values` in their builder function scope.

- Remember, you can help the Flutter Engine to decide where to cache some part of the Widget tree, that will rebuild independently from the rest of the screen with [`RepaintBoundry()`](https://api.flutter.dev/flutter/widgets/RepaintBoundary-class.html), as [setState() can propagate repainting up and down the tree](https://blog.gskinner.com/archives/2020/09/flokk-how-we-built-a-desktop-app-using-flutter.html#performance). Which can lead to a percieved lost frames. Apparently this is more notorious on desktop targets, but is always cool to pay attention to those details... if you have a "big" area of your app that's animated somehow, and you see the performance isn't so great, try to enclose the widget with RepaintBoundry().

## Installation

**just_motion** is in active developing and testing stages. In a couple of days it will be available in pub.dev

In the meantime, if you wanna use it and help me improve it, you should be using dart >= 2.12

Just use this repo url in your _pubspec.yaml_

```yaml
dependencies:
  just_motion:
    git: https://github.com/roipeker/just_motion.git
```

And import **just_motion** in your code:

```dart
import 'package:just_motion/just_motion.dart';
```

Now go, and make your apps comes to life.

Happy coding!

## How to contribute

**just.motion** is open for contributions:

- Helping to fix typos, adjust, translate the readme into other languages.
- Offering PRs for code/tests.
- Making examples.
- Making articles/videos.
- Including new features or discussing the current API.

Any contribution is welcome!

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
