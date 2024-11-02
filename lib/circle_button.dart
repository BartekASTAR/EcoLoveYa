import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final int day;

  CircleButton({
    super.key,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      child: ElevatedButton(
        onPressed: () {},
        child: Text(day.toString()),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(10),
        ),
      ),
    );
  }
}
