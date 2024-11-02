import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 53,
      child: ElevatedButton(
          onPressed: () {},
          child: Text("1"),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(10),
          ),
        ),
    );
  }
}
