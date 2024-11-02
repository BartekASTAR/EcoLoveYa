import 'package:eco_life/circle_button.dart';
import 'package:flutter/material.dart';

class HabitTileWeekly extends StatelessWidget {
  final String habitName;

  const HabitTileWeekly({
    super.key,
    required this.habitName,
  });

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
              children: [Text(habitName)],
            ),
            Row(
              children: [
                Expanded(flex: 15, child: CircleButton(day: 1,)),
                Expanded(flex: 15, child: CircleButton(day: 2,)),
                Expanded(flex: 15, child: CircleButton(day: 3,)),
                Expanded(flex: 15, child: CircleButton(day: 4,)),
                Expanded(flex: 15, child: CircleButton(day: 5,)),
                Expanded(flex: 15, child: CircleButton(day: 6,)),
                Expanded(flex: 15, child: CircleButton(day: 7,)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
