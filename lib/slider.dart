
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatefulSlider extends StatefulWidget {
  @override
  _StatefulSliderState createState() => _StatefulSliderState();
}
class _StatefulSliderState extends State<StatefulSlider> {
  double _valueRed = 100;
  double _valueGreen = 100;
  double _valueBlue = 100;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('RED'),
      Slider(
        min: 0.0,
        max: 1000.0,
        activeColor: Colors.red,
        inactiveColor: Colors.red.shade100,
        thumbColor: Colors.red,
        value: _valueRed,
        onChanged: (value) {
          print('manualdim-red-'+ value.toInt().toString());
          setState(() {
            _valueRed = value;
          });
        },
      ),
      Text('GREEN'),
      Slider(
        min: 0.0,
        max: 1000.0,
        activeColor: Colors.green,
        inactiveColor: Colors.green.shade100,
        thumbColor: Colors.green,
        value: _valueGreen,
        onChanged: (value) {
          print('manualdim-green-'+ value.toInt().toString());
          setState(() {
            _valueGreen = value;
          });
        },
      ),
      Text('BLUE'),
      Slider(
        min: 0.0,
        max: 1000.0,
        activeColor: Colors.blue,
        inactiveColor: Colors.blue.shade100,
        thumbColor: Colors.blue,
        value: _valueBlue,
        onChanged: (value) {
          print('manualdim-blue-'+ value.toInt().toString());
          setState(() {
            _valueBlue = value;
          });
        },
      )
    ]);
  }
}