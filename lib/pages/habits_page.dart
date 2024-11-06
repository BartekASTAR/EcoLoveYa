import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_life/elements/habit_checkbox.dart';
import 'package:eco_life/elements/weekly_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../elements/habit_tile.dart';

class Habits extends StatefulWidget {
  const Habits({super.key});

  @override
  State<Habits> createState() => _HabitsState();
}

class _HabitsState extends State<Habits> {
  final user = FirebaseAuth.instance.currentUser;
  List<bool> trackedHabits = [false, false, false, false, false, false];
  List<String> habitNames = [
    "Nie korzystanie z reklamó",
    "Używanie wielorazowych b",
    "Podnoszenie śmieci",
    "Oszczędzanie wody",
    "Ograniczenie transportu",
    "Dzień bez mięsa"
  ];

  Future _doITrackHabit() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    setState(() {
      List<dynamic> dynamicList = snapshot.get('trackedHabits');
      trackedHabits = dynamicList.map((item) => item as bool).toList();
    });
  }

  void _trackedHabitChange() async {
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
      'trackedHabits': trackedHabits,
    });
    setState(() {});
    Navigator.pop(context);
  }

  int howManyHabitsTracked() {
    int counter = 0;
    for (int i = 0; i < trackedHabits.length; i++) {
      if (trackedHabits[i]) {
        counter++;
      }
    }
    return counter;
  }

  @override
  void initState() {
    _doITrackHabit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Text("Dodaj nawyk"),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return FutureBuilder(
                          future: _doITrackHabit(),
                          builder: (context, snapshot) {
                            return AlertDialog(
                              title: Text("Twoje nawyki:"),
                              content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    for (int i = 0;
                                        i < trackedHabits.length;
                                        i++)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(habitNames[i]),
                                          HabitCheckbox(
                                              list: trackedHabits, index: i)
                                        ],
                                      )
                                  ]),
                              actions: [
                                ElevatedButton(
                                    onPressed: _trackedHabitChange,
                                    child: const Text("Akceptuj"))
                              ],
                            );
                          });
                    });
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: ListView(
          children: [
            WeeklyBar(),
            for (int i = 0; i < howManyHabitsTracked(); i++)
              HabitTile(habitName: i.toString()),
          ],
        ));
  }
}
