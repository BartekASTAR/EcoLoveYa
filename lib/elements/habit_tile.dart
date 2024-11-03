import 'package:flutter/material.dart';

class HabitTile extends StatelessWidget {
  final String habitName;

  const HabitTile({
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
              children: [],
            ),
          ],
        ),
      ),
    );
  }
}
