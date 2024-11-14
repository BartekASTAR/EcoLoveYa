import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_life/elements/habit_checkbox.dart';
import 'package:eco_life/elements/weekly_bar_stats.dart';
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
  List<bool> trackedHabitsBool = [false, false, false, false, false, false];
  List<int> trackedHabitsIds = [];
  List<String> habitNames = [
    "Wielorazowe torby",
    "Wielorazowe butelki",
    "Podnoszenie śmieci",
    "Oszczędzanie wody",
    "Ograniczenie samochodu",
    "Dzień bez mięsa"
  ];
  List<String> habitTypes = [
    "plastik, CO2",
    "plastik, CO2",
    "plastik, CO2",
    "woda",
    "CO2",
    "CO2",
  ];

  Future _doITrackHabit() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    setState(() {
      List<dynamic> dynamicList = snapshot.get('trackedHabits');
      trackedHabitsBool = dynamicList.map((item) => item as bool).toList();
    });
  }

  void _trackedHabitChange() async {
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
      'trackedHabits': trackedHabitsBool,
    });
    setState(() {});
    Navigator.pop(context);
  }

  int _howManyHabitsTracked() {
    int counter = 0;
    trackedHabitsIds = [];
    for (int i = 0; i < trackedHabitsBool.length; i++) {
      if (trackedHabitsBool[i]) {
        counter++;
        trackedHabitsIds.add(i);
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
            Text("Śledź nawyki", style: TextStyle(fontSize: 16)),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return FutureBuilder(
                          future: _doITrackHabit(),
                          builder: (context, snapshot) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.fromSwatch()
                                      .copyWith(primary: Colors.green[400])),
                              child: AlertDialog(
                                title: Text("Twoje nawyki:"),
                                content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (int i = 0;
                                          i < trackedHabitsBool.length;
                                          i++)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              habitNames[i],
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            HabitCheckbox(
                                                list: trackedHabitsBool,
                                                index: i)
                                          ],
                                        )
                                    ]),
                                actions: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.green.shade400),
                                      onPressed: _trackedHabitChange,
                                      child: const Text(
                                        "Akceptuj",
                                        style: TextStyle(color: Colors.white),
                                      ))
                                ],
                              ),
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
            WeeklyBarStats(),
            //WeeklyBar(),
            //NumbersWidget(),
            SizedBox(
              height: 20,
            ),
            for (int i = 0; i < _howManyHabitsTracked(); i++)
              HabitTile(
                habitName: habitNames[trackedHabitsIds[i]],
                habitId: trackedHabitsIds[i],
                trackedHabits: trackedHabitsIds,
                habitType: habitTypes[i],
              ),
          ],
        ));
  }
}
