import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  String title;
  double defaultValue;
  double min;
  double max;
  int divisions;
  SliderWidget({@required this.title, @required this.min, @required this.max, @required this.divisions, @required this.defaultValue});
  @override
  _SliderWidgetState createState() => _SliderWidgetState(title: this.title, min: this.min, max: this.max, defaultValue: this.defaultValue, divisions: this.divisions);
}

class _SliderWidgetState extends State<SliderWidget> {
  String title;
  double defaultValue;
  double min;
  double max;
  int divisions;
  _SliderWidgetState({@required this.title, @required this.min, @required this.max, @required this.divisions, @required this.defaultValue});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.title),
      children: [
        new Slider(
          value: defaultValue,
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          label: defaultValue.round().toString(),
          onChanged: (double value) {
            setState(() {
              defaultValue = value;
            });
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, defaultValue);
          },
          child: Text('DONE'),
        ),
      ],
    );
  }
}