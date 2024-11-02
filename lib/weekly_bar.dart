import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyBar extends StatefulWidget {
  @override
  _WeeklyBarState createState() => _WeeklyBarState();
}

class _WeeklyBarState extends State<WeeklyBar> {
  int selectedDayIndex = 0; // Automatycznie zaktualizujemy dla dzisiejszej daty
  final List<String> days = ['P', 'W', 'Ś', 'C', 'P', 'S', 'N'];
  List<int> dates = [];

  @override
  void initState() {
    super.initState();
    _initializeCurrentWeek();
  }

  void _initializeCurrentWeek() {
    DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1)); // Poniedziałek tego tygodnia
    dates = List.generate(7, (index) => monday.add(Duration(days: index)).day);

    // Zaznacz dzisiejszy dzień
    selectedDayIndex = now.weekday - 1; // 0 dla poniedziałku, 1 dla wtorku, itd.

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(days.length, (index) {
          bool isSelected = index == selectedDayIndex;
          return GestureDetector(
            onTap: () {
              //TODO: Sprawić, że po kliknięciu łączy się z bazą danych
              setState(() {
                selectedDayIndex = index;
              });
            },
            child: Column(
              children: [
                Text(
                  days[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.green : Colors.grey,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    dates[index].toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}