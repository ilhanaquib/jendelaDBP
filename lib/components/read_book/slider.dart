import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double _sliderValue = 1.0;

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: Slider(
        value: _sliderValue,
        onChanged: _onSliderChanged,
        min: 1,
        max: 100,
        activeColor: DbpColor().jendelaOrange,
        
      ),
    );
  }
}
