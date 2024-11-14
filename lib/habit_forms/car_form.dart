import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_provider.dart';

class CarForm extends StatefulWidget {
  const CarForm({super.key});

  @override
  State<CarForm> createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  String dropdownValue = "Autobus";
  final distanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    void _updateDatabase() async {
      double emissionCar = 120;
      double emissionValue = 0;
      switch (dropdownValue) {
        case "Autobus":
          emissionValue = 70;
          break;
        case "Tramwaj":
          emissionValue = 25;
          break;
        case "Rower":
          emissionValue = 0;
          break;
        case "Nogi":
          emissionValue = 0;
          break;
        default:
          break;
      }

      double result =
          (double.parse(distanceController.text.trim()) * emissionCar) -
              (double.parse(distanceController.text.trim()) * emissionValue);

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid!)
          .collection('dates')
          .doc(context.read<DataProvider>().selectedDate)
          .get();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid!)
          .collection('dates')
          .doc(context.read<DataProvider>().selectedDate)
          .update({
        "car_emission": snapshot["car_emission"] + result,
      });
    }

    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Środek transportu: ",
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.menu),
                  underline: Container(
                    height: 2,
                    color: Colors.green.shade400,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: const [
                    DropdownMenuItem<String>(
                      value: "Autobus",
                      child: Text("Autobus"),
                    ),
                    DropdownMenuItem<String>(
                      value: "Tramwaj",
                      child: Text("Tramwaj"),
                    ),
                    DropdownMenuItem<String>(
                      value: "Rower",
                      child: Text("Rower"),
                    ),
                    DropdownMenuItem<String>(
                      value: "Nogi",
                      child: Text("Nogi"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dystans: ",
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                  width: 104,
                  decoration: BoxDecoration(
                    //color: Colors.grey[200],
                    border: Border.all(), //color: Colors.white
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextField(
                      controller: distanceController,
                      cursorColor: Colors.green[400],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "km",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: GestureDetector(
              onTap: () {
                _updateDatabase();
                Navigator.pop(context, "update");
              },
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                    child: Text(
                  'Dodaj',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                )),
              ),
            ),
          )
        ],
      ),
    );
    ;
  }
}
