import 'package:eco_life/pages/habit_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_provider.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final int habitId;
  final String habitType;
  final List<int> trackedHabits;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.habitType,
    required this.habitId,
    required this.trackedHabits,
  });

  @override
  Widget build(BuildContext context) {
    List<IconData> iconList = [
      Icons.shopping_bag,
      Icons.local_drink,
      Icons.delete,
      Icons.shower,
      Icons.directions_car,
      Icons.restaurant
    ];
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () async {
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HabitDetailsPage(
                        habitId: habitId,
                        habitName: habitName,
                      )));
          if (result == "update") {
            context.read<DataProvider>().setShouldRefresh(true);
          }
        },
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.green[400],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habitName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        habitType,
                        style: TextStyle(fontSize: 13),
                        textAlign: TextAlign.start,
                      )
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    iconList[habitId],
                    size: 40,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
