import 'package:eco_life/habit_forms/bag_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../habit_forms/bottle_form.dart';
import '../habit_forms/car_form.dart';
import '../habit_forms/meat_form.dart';
import '../habit_forms/trash_form.dart';
import '../habit_forms/water_form.dart';

class HabitDetailsPage extends StatefulWidget {
  final int habitId;
  final String habitName;

  const HabitDetailsPage(
      {super.key, required this.habitId, required this.habitName});

  @override
  State<HabitDetailsPage> createState() => _HabitDetailsPageState();
}

class _HabitDetailsPageState extends State<HabitDetailsPage> {
  List<String> descriptionList = [
    'Zamiast za każdym razem kupować i używać reklamówkę, skorzystaj z wielorazowej torby np. materiałowej!',
    'Zamiast kupować wodę butelkowaną i generować ogromne ilości plastiku, korzystaj z wielorazowych bidonów i butelek z filtrem!',
    'Zobaczyłeś jakiś śmieć leżący na ziemi? Podnieś go i wyrzuć do odpowiedniego śmietnika! To drobna rzecz, a może wiele zrobić dla naszej planety!',
    'Prysznic średnio zajmujący 10 minut może generować tylko trochę mniejsze zużycie wody niż kąpiel w wannie! Spróbój  jednak skrócić ten czas nawet o kilka minut, aby zminimalizować zużycie wody.',
    'Podróżowanie samochodem generuje mnóstwo zanieczyszczeń. Skorzystaj z mniej emisyjnych środków transportu!',
    'Przy produkcji mięsa wytwarzane są ogromne ilości dwutlenku węgla. Rezygnacja ze spożywania mięsa na chociaż jeden dzień może mocno zmniejszyć twoją emisyjność.',
    'Błąd!!'
  ];
  late String description;
  late Widget formWidget;

  void _showProperForm(int habitId) {
    switch (habitId) {
      case 0:
        description = descriptionList[0];
        formWidget = BagForm();
        break;
      case 1:
        description = descriptionList[1];
        formWidget = BottleForm();
        break;
      case 2:
        description = descriptionList[2];
        formWidget = TrashForm();
        break;
      case 3:
        description = descriptionList[3];
        formWidget = WaterForm();
        break;
      case 4:
        description = descriptionList[4];
        formWidget = CarForm();
        break;
      case 5:
        description = descriptionList[5];
        formWidget = MeatForm();
        break;
      default:
        description = descriptionList[6];
        formWidget = Column();
        break;
    }
  }

  @override
  void initState() {
    _showProperForm(widget.habitId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.habitName,
              style: GoogleFonts.bebasNeue(fontSize: 32),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              description,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            formWidget,
          ],
        ),
      ),
    );
  }
}
