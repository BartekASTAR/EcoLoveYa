import 'package:eco_life/habit_tile.dart';
import 'package:flutter/material.dart';

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
          HabitTile(),
          HabitTile(),
          HabitTile(),
        ],
      )
      );
  }
}
