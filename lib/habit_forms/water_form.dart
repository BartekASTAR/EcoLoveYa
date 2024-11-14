import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_provider.dart';

class WaterForm extends StatefulWidget {
  const WaterForm({super.key});

  @override
  State<WaterForm> createState() => _WaterFormState();
}

class _WaterFormState extends State<WaterForm> {
  final durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    void _updateDatabase() async {
      int flow_per_minute = 12;
      int duration = int.parse(durationController.text.trim());

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
        "water_usage":
            snapshot["water_usage"] + (140 - (duration * flow_per_minute)),
      });
    }

    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Czas prysznica: ",
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
                      controller: durationController,
                      cursorColor: Colors.green[400],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "min",
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
  }
}
