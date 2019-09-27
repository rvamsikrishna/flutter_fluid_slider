import 'package:flutter/material.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  double _value1 = 0.0;
  double _value2 = 10.0;
  double _value3 = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
            SizedBox(
              height: 100.0,
            ),
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
            SizedBox(
              height: 100.0,
            ),
            FluidSlider(
                value: _value3,
                sliderColor: Colors.purple,
                onChanged: (double newValue) {
                  setState(() {
                    _value3 = newValue;
                  });
                },
                min: 1.0,
                max: 5.0,
                mapValueToString: (double value) {
                  List<String> romanNumerals = ['I', 'II', 'III', 'IV', 'V'];
                  return romanNumerals[value.toInt() - 1];
                }),
          ],
        ),
      ),
    );
  }
}
