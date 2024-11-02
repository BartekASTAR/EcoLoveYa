import 'package:eco_life/habit_tile_weekly.dart';
import 'package:eco_life/weekly_bar.dart';
import 'package:flutter/material.dart';

import 'habit_tile.dart';

class Habits extends StatefulWidget {
  const Habits({super.key});

  @override
  State<Habits> createState() => _HabitsState();
}

class _HabitsState extends State<Habits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Text("Dodaj"),
          IconButton(
            onPressed: () {}, // Dodać metodę
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body:ListView(
        children: [
          WeeklyBar(),
          HabitTile(habitName: "Nazwa1"),
          HabitTile(habitName: "Nazwa2"),
          HabitTile(habitName: "Nazwa3"),
        ],
      )
      );
  }
}
