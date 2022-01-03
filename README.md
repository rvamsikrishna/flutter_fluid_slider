# Fluid Slider for Flutter

<a href="https://github.com/Solido/awesome-flutter">
   <img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>

Inspired by a dribbble by [Virgil Pana](https://dribbble.com/virgilpana).

![demo](https://i.imgur.com/34mAvRj.gif)

A fluid design slider that works just like the [Slider](https://docs.flutter.io/flutter/material/Slider-class.html) material widget.

Used to select from a range of values.

## Installation

Just add the package to your dependencies in the `pubspec.yaml` file:

```yaml
dependencies:
  flutter_fluid_slider: ^1.0.2
```

### Basic Usage

Place the `FluidSlider` in your widget tree.

```dart
FluidSlider(
  value: _value,
  onChanged: (double newValue) {
    setState(() {
      _value = newValue;
    });
  },
  min: 0.0,
  max: 100.0,
),
```

### Properties

- `value` : [**Required**] The currently selected value for this slider. The slider's thumb is drawn at a position that corresponds to this value.

- `min` : The minimum value the user can select. Defaults to `0.0`. Must be less than or equal to `max`.

- `max` : The maximum value the user can select. Defaults to `1.0`. Must be less than or equal to `min`.

- `start` : The widget to be displayed as the min label. For eg: an Icon can be displayed. If not provided the `min` value is displayed as text.

- `end` : The widget to be displayed as the max label. For eg: an Icon can be displayed. If not provided the `max` value is displayed as text.

- `onChanged` : [**Required**] Called during a drag when the user is selecting a new value for the slider

  by dragging.

  - The slider passes the new value to the callback but does not actually change state until the parent widget rebuilds the slider with the new value.

  - If null, the slider will be displayed as disabled.

- `onChangeStart` : Called when the user starts selecting a new value for the slider. The value passed will be the last `value` that the slider had before the change began.

- `onChangeEnd` : Called when the user is done selecting a new value for the slider.

- `labelsTextStyle` : The styling of the min and max text that gets displayed on the slider. If not provided the ancestor `Theme`'s `accentTextTheme` text style will be applied.

- `valueTextStyle` : The styling of the current value text that gets displayed on the slider. If not provided the ancestor `Theme`'s `textTheme.title` text style with bold will be applied .

- `sliderColor` : The color of the slider. If not provided the ancestor `Theme`'s `primaryColor` will be applied.

- `thumbColor` : The color of the thumb. If not provided the `Colors.white` will be applied.

- `showDecimalValue` : Whether to display the first decimal value of the slider value. Defaults to `false`.

- `mapValueToString` : called with value for the String to be rendered in the slider's thumb.     E.g. display roman integers as follows:
    ```dart
    FluidSlider(
      value:_val,
      min:1.0,
      max:5.0,
      onChanged:(){},
      mapValueToString: (double value){
        List<String> romanNumerals=['I', 'II', 'III', 'IV', 'V'];
        return _romanNumerals[value.toInt() - 1];
      }
    )
    ```
    See [example](https://github.com/rvamsikrishna/flutter_fluid_slider/blob/master/example/lib/main.dart#L82). If null the value is converted to String based on [showDecimalValue]. 


#### Credits:

- [Ramotion](https://dribbble.com/shots/5343166-Fluid-Slider-Optimized-iOS-Control-Open-Source) - implementation for ios and android
- [Virgil Pana](https://dribbble.com/virgilpana) - creating the original concept
