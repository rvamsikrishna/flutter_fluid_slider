# Basic Example

Import the package and add the `FluidSlider` to your widget tree

```dart
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';

FluidSlider(
  value: _value1,
  onChanged: (double newValue) {
    setState(() {
      _value1 = newValue;
    });
  },
  min: 0.0,
  max: 100.0,
),
```

You can also add other widgets like `Icon` as your `min` and `max` labels:

```dart
FluidSlider(
  value: _value2,
  onChanged: (double newValue) {
    setState(() {
      _value2 = newValue;
    });
  },
  min: 0.0,
  max: 500.0,
  sliderColor: Colors.redAccent,
  thumbColor: Colors.amber,
  start: Icon(
    Icons.money_off,
    color: Colors.white,
  ),
  end: Icon(
    Icons.attach_money,
    color: Colors.white,
  ),
),
```

For all the properties, check out the [docs](https://pub.dartlang.org/documentation/flutter_fluid_slider/latest/flutter_fluid_slider/FluidSlider-class.html).

