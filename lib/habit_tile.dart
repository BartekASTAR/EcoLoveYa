import 'package:eco_life/circle_button.dart';
import 'package:flutter/material.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [Text("Nazwa")],
            ),
            Row(
              children: [
                CircleButton(),
                CircleButton(),
                CircleButton(),
                CircleButton(),
                CircleButton(),
                CircleButton(),
                CircleButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
