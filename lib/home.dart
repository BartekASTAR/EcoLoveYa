import 'package:eco_life/pages/habits_page.dart';
import 'package:eco_life/pages/profil_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//TextButton(onPressed: () {
//Navigator.push(context,
//MaterialPageRoute(builder: (context) => BasketPage()));
//}, child: Text('Go to basket')),

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _selectedIndex = 1;

  // String name = FirebaseFirestore.instance.collection('users').doc(user.uid).get("nickName"); //TODO dodać żeby wyświetlała się nazwa uytkownika
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[
    const ProfilPage(),
    const Habits(),
    const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          textAlign: TextAlign.center,
          'Znajomi',
          style: optionStyle,
        ),
        Text(
          textAlign: TextAlign.center,
          'do dodania w przyszłości ;)',
          style: TextStyle(fontSize: 14),
        ),
      ],
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_rounded),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Nawyki',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake_rounded),
            label: 'Znajomi',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
