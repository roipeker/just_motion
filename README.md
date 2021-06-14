# just.motion

Flutter package to create organic motion transitions using basic numeric integrations.


## why?
Why not? well, the basic difference with `Tweens` is that the change in value looks much cooler, it feels more "organic, while Tweens are more "mechanic". 

`motion` is not based on `Durations` and interpolated values from 0-1, but rather on distance between the current value and the target value. 
On the other hand, it doesn't need a Ticker provider, nor a huge set of Implicit widgets. Also no need for AnimationControllers.

There's a single internal Ticker, that manages it's own state based on the auto-subscribed `MotionValues`. 
When there're no active motions, it just stops. 

Also, it has a very simple reactive support `MotionValue`s when consumed inside a `Motion()` or `MotionBuilder()` widget.

So, is a great option for your app's animations! as subscriptions and memory management are also automatic when using `MotionValue` with the provided `Motion` widgets.

## The Motion Value:

Here's how it works: 

Declare a var that you will use to animate some widget property:

```dart
final height = EulerValue( 30 );
///or the extension approach.
final height = 30.euler();

final bgColor = EulerColor( Colors.red );
final bgColor = Colors.red.euler();
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

This is what makes **motion** shine, you can change the `target` anytime, and it will smoothly transition towards it, without mechanic or abrupt visual cuts, like regular Curved Tweens.

To read the current value:
```dart
print( height());
// or
print( height.value );
```

The motion objects detects when `target` is modified, and runs the simulation accordingly.
A motion object is idle, when `value` reaches `target`, and will be unsubscribed from the ticker provider.

To stop the animation, set the **`motion.value = motion.target`**, otherwise the ticker will keep running until the values are closed enough to stop deactivate.

You can set an absolute value to rebuild the widget, preventing the animation, with:
`height.value = height.target = 10;`

or better yet:
`height.set( 10 );`


## The Widgets:

`MotionValue` is a ChangeNotifier, so you can use `AnimationBuilder`:


```dart
@override
  Widget build(BuildContext context) {
    final height = 24.0.euler(target: 120, ease: 23);
    final bgColor = Colors.black12.euler(ease: 45);
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


## installation

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


## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
