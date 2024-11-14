import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_provider.dart';

class TrashForm extends StatelessWidget {
  const TrashForm({super.key});

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
        "trash_mass": snapshot["trash_mass"] + 12,
        "trash_emission": snapshot["trash_emission"] + 10,
      });
      print(snapshot["bag_mass"]);
    }

    return Container(
      child: Column(
        children: [
          Text(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
              "Czy wyrzuciłeś znaleźony śmieć do odpowiedniego pojemnika?"),
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
