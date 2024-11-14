import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_life/data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BagForm extends StatefulWidget {
  const BagForm({super.key});

  @override
  State<BagForm> createState() => _BagFormState();
}

class _BagFormState extends State<BagForm> {
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
        "bag_mass": snapshot["bag_mass"] + 10,
        "bag_emission": snapshot["bag_emission"] + 8,
      });
      setState(() {});
    }

    return Container(
      child: Column(
        children: [
          Text(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
              "Czy zamiast z rekalmówki skorzystałeś dzisiaj z torby wielorazowej?"),
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
          ),
        ],
      ),
    );
  }
}
