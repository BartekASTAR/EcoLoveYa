import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NumbersWidget extends StatefulWidget {
  @override
  State<NumbersWidget> createState() => _NumbersWidgetState();
}

class _NumbersWidgetState extends State<NumbersWidget> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  int totalMass = 0;
  double totalEmission = 0;
  int totalUsage = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  Future<void> fetchStats() async {
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid!)
        .collection("dates");
    QuerySnapshot querySnapshot = await collectionRef.get();

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      data.forEach((key, value) {
        if (key.endsWith('_mass') && value is int) {
          totalMass += value;
        }
        if (key.endsWith('_emission') && value is double) {
          totalEmission += value;
        }
        if (key.endsWith('_usage') && value is int) {
          totalUsage += value;
        }
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  Widget buildDivider() => Container(
    height: 28,
    child: VerticalDivider(),
  );

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.green.shade400,
        ),
      );
    }

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButton(context, totalMass.toString(), 'g plastiku'),
          buildDivider(),
          buildButton(
              context, totalUsage.toString(), 'l wody'), // tu można podmienić na inną wartość
          buildDivider(),
          buildButton(context, (totalEmission / 1000).toString(), 'kg CO2'),
        ],
      ),
    );
  }
}
