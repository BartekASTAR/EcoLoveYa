import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_provider.dart';
import '../elements/numbers_widget.dart';
import '../elements/profile_widget.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  // TODO Gdzie użyć tej funkcji, aby wcześniej pobrać dane????
  late Future<DocumentSnapshot> nickname;
  String name = "";

  Future<DocumentSnapshot> fetchData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  @override
  void initState() {
    nickname = fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: context.watch<DataProvider>().isDarkTheme
                ? Icon(Icons.light_mode)
                : Icon(Icons.dark_mode),
            onPressed: () {
              context.read<DataProvider>().toggleTheme();
              setState(() {});
            },
          )
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: nickname,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData && snapshot.data!.exists) {
              name = snapshot.data?["nickName"];
              return ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  ProfileWidget(
                    imagePath: "assets/images/placeHolder.jpg",
                    onClicked: () async {},
                  ),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 28),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Statystyki:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  NumbersWidget(),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: FirebaseAuth.instance.signOut,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.green[400],
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                            child: Text(
                          'Wyloguj się',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Text("Nie znaleziono danych użytkownika!");
          }),
    );
  }
}
