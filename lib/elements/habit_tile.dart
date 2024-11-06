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
      child: GestureDetector(
        onTap: () {},
        //TODO Dodać pojawiające się okno dialogowe z możliwością wprowadzenia danych do nawyku
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[400],
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
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        "Typ",
                        textAlign: TextAlign.start,
                      )
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [Text("Wartość")],
              )
            ],
          ),
        ),
      ),
    );
  }
}
