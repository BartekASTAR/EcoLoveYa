import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_provider.dart';

class BottleForm extends StatelessWidget {
  const BottleForm({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    void _updateDatabase() async {
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
        "bottle_mass": snapshot["bottle_mass"] + 25,
        "bottle_emission": snapshot["bottle_emission"] + 34,
      });
    }

    return Container(
      child: Column(
        children: [
          Text(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
              "Czy skorzystałeś z wielorazowej butelki?"),
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
