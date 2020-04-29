import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

///A fluid design slider that works just like the [Slider] material widget.
///
/// Used to select from a range of values.
///
/// The fluid slider will be disabled if [onChanged] is null.
///
///
/// By default, a fluid slider will be as wide as possible, with a height of 60.0. When
/// given unbounded constraints, it will attempt to make itself 200.0 wide.
///

class FluidSlider extends StatefulWidget {
  ///Creates a fluid slider
  ///
  /// * [value] determines currently selected value for this slider.
  /// * [onChanged] is called while the user is selecting a new value for the
  ///   slider.
  /// * [onChangeStart] is called when the user starts to select a new value for
  ///   the slider.
  /// * [onChangeEnd] is called when the user is done selecting a new value for
  ///   the slider.
  ///
  ///
  ///
  /// The currently selected value for this slider.
  ///
  /// The slider's thumb is drawn at a position that corresponds to this value.
  final double value;

  /// The minimum value the user can select.
  ///
  /// Defaults to 0.0. Must be less than or equal to [max].
  final double min;

  /// The maximum value the user can select.
  ///
  /// Defaults to 1.0. Must be greater than or equal to [min].
  final double max;

  ///The widget to be displayed as the min label. For eg: an Icon can be displayed.
  ///
  ///If not provided the [min] value is displayed as text.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// FluidSlider(
  ///   value: _value,
  ///   min: 1.0,
  ///   max: 100.0,
  ///   start: Icon(
  ///     Icons.money_off,
  ///     color: Colors.white,
  ///   ),
  ///   onChanged: (double newValue) {
  ///     setState(() {
  ///       _duelCommandment = newValue.round();
  ///     });
  ///   },
  /// )
  /// ```
  ///
  final Widget start;

  ///The widget to be displayed as the max label. For eg: an Icon can be displayed.
  ///
  ///If not provided the [max] value is displayed as text.
  final Widget end;

  /// Called during a drag when the user is selecting a new value for the slider
  /// by dragging.
  ///
  /// The slider passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the slider with the new
  /// value.
  ///
  /// If null, the slider will be displayed as disabled.

  final ValueChanged<double> onChanged;

  /// Called when the user starts selecting a new value for the slider.
  ///
  /// The value passed will be the last [value] that the slider had before the
  /// change began.
  final ValueChanged<double> onChangeStart;

  /// Called when the user is done selecting a new value for the slider.
  final ValueChanged<double> onChangeEnd;

  ///The styling of the min and max text that gets displayed on the slider
  ///
  ///If not provided the ancestor [Theme]'s [accentTextTheme] text style will be applied.
  final TextStyle labelsTextStyle;

  ///The styling of the current value text that gets displayed on the slider
  ///
  ///If not provided the ancestor [Theme]'s [textTheme.title] text style
  ///with bold will be applied .
  final TextStyle valueTextStyle;

  ///The color of the slider.
  ///
  ///If not provided the ancestor [Theme]'s [primaryColor] will be applied.
  final Color sliderColor;

  ///The color of the thumb.
  ///
  ///If not provided the [Colors.white] will be applied.
  final Color thumbColor;

  ///Whether to display the first decimal value of the slider value
  ///
  ///defaults to false
  final bool showDecimalValue;

  ///Callback function to map the double values to String texts
  ///
  ///If null the value is converted to String based on [showDecimalValue]
  final String Function(double) mapValueToString;

  ///The diameter of the thumb, it's also the height of the slider
  ///
  ///defaults to 60.0
  final double thumbDiameter;

  const FluidSlider({
    Key key,
    @required this.value,
    this.min = 0.0,
    this.max = 1.0,
    this.start,
    this.end,
    @required this.onChanged,
    this.labelsTextStyle,
    this.valueTextStyle,
    this.onChangeStart,
    this.onChangeEnd,
    this.sliderColor,
    this.thumbColor,
    this.mapValueToString,
    this.showDecimalValue = false,
    this.thumbDiameter,
  })  : assert(value != null),
        assert(min != null),
        assert(max != null),
        assert(min <= max),
        assert(value >= min && value <= max),
        super(key: key);
  @override
  _FluidSliderState createState() => _FluidSliderState();
}

class _FluidSliderState extends State<FluidSlider>
    with SingleTickerProviderStateMixin {
  double _sliderWidth;
  double _currX = 0.0;
  AnimationController _animationController;
  CurvedAnimation _thumbAnimation;
  double thumbDiameter;

  @override
  initState() {
    super.initState();
    //The radius of the slider thumb control
    thumbDiameter = widget.thumbDiameter ?? 60.0;
    _animationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _thumbAnimation = CurvedAnimation(
      curve: Curves.bounceOut,
      parent: _animationController,
    );
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Offset _getGlobalToLocal(Offset globalPosition) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    return renderBox.globalToLocal(globalPosition);
  }

  void _onHorizontalDragDown(DragDownDetails details) {
    if (_isInteractive) {
      _animationController.forward();
    }
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    if (_isInteractive) {
      if (widget.onChangeStart != null) {
        _handleDragStart(widget.value);
      }
      _currX = _getGlobalToLocal(details.globalPosition).dx / _sliderWidth;
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_isInteractive) {
      final double valueDelta = details.primaryDelta / _sliderWidth;
      _currX += valueDelta;

      _handleChanged(_clamp(_currX));
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (widget.onChangeEnd != null) {
      _handleDragEnd(_clamp(_currX));
    }
    _currX = 0.0;
    _animationController.reverse();
  }

  void _onHorizontalDragCancel() {
    if (widget.onChangeEnd != null) {
      _handleDragEnd(_clamp(_currX));
    }
    _currX = 0.0;
    _animationController.reverse();
  }

  double _clamp(double value) {
    return value.clamp(0.0, 1.0);
  }

  void _handleChanged(double value) {
    assert(widget.onChanged != null);
    final double lerpValue = _lerp(value);
    if (lerpValue != widget.value) {
      widget.onChanged(lerpValue);
    }
  }

  void _handleDragStart(double value) {
    assert(widget.onChangeStart != null);
    widget.onChangeStart((value));
  }

  void _handleDragEnd(double value) {
    assert(widget.onChangeEnd != null);
    widget.onChangeEnd((_lerp(value)));
  }

  // Returns a number between min and max, proportional to value, which must
  // be between 0.0 and 1.0.
  double _lerp(double value) {
    assert(value >= 0.0);
    assert(value <= 1.0);
    return value * (widget.max - widget.min) + widget.min;
  }

  // Returns a number between 0.0 and 1.0, given a value between min and max.
  double _unlerp(double value) {
    assert(value <= widget.max);
    assert(value >= widget.min);
    return widget.max > widget.min
        ? (value - widget.min) / (widget.max - widget.min)
        : 0.0;
  }

  Color get _sliderColor {
    if (_isInteractive) {
      return widget.sliderColor ?? Theme.of(context).primaryColor;
    } else {
      return Colors.grey;
    }
  }

  Color get _thumbColor {
    if (_isInteractive) {
      return widget.thumbColor ?? Colors.white;
    } else {
      return Colors.grey[300];
    }
  }

  bool get _isInteractive => widget.onChanged != null;

  TextStyle _currentValTextStyle(BuildContext context) {
    final TextStyle defaultStyle = widget.showDecimalValue
        ? Theme.of(context)
            .textTheme
            .subhead
            .copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context)
            .textTheme
            .title
            .copyWith(fontWeight: FontWeight.bold);

    return widget.valueTextStyle ?? defaultStyle;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        //The offset of the thumb so that it does not touch the slider border when at min/max position.
        final double thumbPadding = 8.0;
        //The value by which the thum positions should interpolate.
        final double thumbPosFactor = _unlerp(widget.value);
        double remainingWidth;

        //Setting the slider width to its parent's max width if constraint width is present else set to 200.0
        //This is used to compute the thumb position and also
        //calculate the delta drag value in the horizontal drag handlers.
        _sliderWidth =
            constraints.hasBoundedWidth ? constraints.maxWidth : 200.0;

        //The width remaining for the thumb to be dragged upto.
        remainingWidth = _sliderWidth - thumbDiameter - 2 * thumbPadding;

        //The position of the thumb control of the slider from max value.
        final double thumbPositionLeft =
            lerpDouble(thumbPadding, remainingWidth, thumbPosFactor);

        //The position of the thumb control of the slider from min value.
        final double thumbPositionRight =
            lerpDouble(remainingWidth, thumbPadding, thumbPosFactor);

        //Start position of slider thumb.
        final RelativeRect beginRect = RelativeRect.fromLTRB(
            thumbPositionLeft, 0.00, thumbPositionRight, 0.0);

        //Popped up position of slider thumb.
        final poppedPosition = thumbDiameter + 5;
        final RelativeRect endRect = RelativeRect.fromLTRB(thumbPositionLeft,
            poppedPosition * -1, thumbPositionRight, poppedPosition);

        //Describes the position of the thumb slider.
        //Mainly useful to animate the thumb popping up.
        Animation<RelativeRect> thumbPosition = RelativeRectTween(
          begin: beginRect,
          end: endRect,
        ).animate(_thumbAnimation);

        return Container(
          width: _sliderWidth,
          height: thumbDiameter,
          decoration: BoxDecoration(
            color: _sliderColor,
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(10.0),
              right: Radius.circular(10.0),
            ),
          ),
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              _MinMaxLabels(
                textStyle: widget.labelsTextStyle,
                alignment: Alignment.centerLeft,
                child: widget.start,
                value: widget.min,
                padding: EdgeInsets.only(left: 15.0),
              ),
              _MinMaxLabels(
                textStyle: widget.labelsTextStyle,
                alignment: Alignment.centerRight,
                child: widget.end,
                value: widget.max,
                padding: EdgeInsets.only(right: 15.0),
              ),
              PositionedTransition(
                rect: thumbPosition,
                child: CustomPaint(
                  painter: _ThumbSplashPainter(
                    showContact: _animationController,
                    thumbPadding: thumbPadding,
                    splashColor: _sliderColor,
                  ),
                  child: GestureDetector(
                    onHorizontalDragCancel: _onHorizontalDragCancel,
                    onHorizontalDragDown: _onHorizontalDragDown,
                    onHorizontalDragStart: _onHorizontalDragStart,
                    onHorizontalDragUpdate: _onHorizontalDragUpdate,
                    onHorizontalDragEnd: _onHorizontalDragEnd,
                    child: Container(
                      width: thumbDiameter,
                      height: thumbDiameter,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _sliderColor,
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: 0.75 * thumbDiameter,
                        height: 0.75 * thumbDiameter,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _thumbColor,
                        ),
                        child: Center(
                          child: Text(
                            widget.mapValueToString != null
                                ? widget.mapValueToString(widget.value)
                                : widget.showDecimalValue
                                    ? widget.value.toStringAsFixed(1)
                                    : widget.value.toInt().toString(),
                            style: _currentValTextStyle(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThumbSplashPainter extends CustomPainter {
  final Animation showContact;
  //This is passed to calculate and compensate the value
  //of x for drawing the sticky fluid
  final thumbPadding;
  final Color splashColor;

  _ThumbSplashPainter({this.thumbPadding, this.showContact, this.splashColor});

  @override
  void paint(Canvas canvas, Size size) {
    // print(size);
    if (showContact.value >= 0.5) {
      final Offset center = Offset(size.width / 2, size.height / 2);

      final Path path = Path();
      path.moveTo(-0.0, size.height + 6.0);
      path.quadraticBezierTo(
          center.dx, size.height, thumbPadding / 2, center.dy);

      path.lineTo(size.width - thumbPadding / 2, center.dy);

      path.quadraticBezierTo(
          center.dx, size.height, size.width + 0.0, size.height + 6.0);

      path.close();
      canvas.drawPath(path, Paint()..color = splashColor);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _MinMaxLabels extends StatelessWidget {
  final Alignment alignment;
  final TextStyle textStyle;
  final Widget child;
  final double value;
  final EdgeInsets padding;

  const _MinMaxLabels({
    Key key,
    this.alignment,
    this.textStyle,
    this.child,
    this.value,
    this.padding,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Align(
        alignment: alignment,
        child: child ??
            Text(
              '${value.toInt()}',
              style: textStyle ?? Theme.of(context).accentTextTheme.title,
            ),
      ),
    );
  }
}
