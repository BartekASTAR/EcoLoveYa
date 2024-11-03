import 'package:eco_life/pages/habits_page.dart';
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
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[
    Column(
      children: [
        Text('Signed in as a: '),
        MaterialButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          child: const Text("sign out"),
        ),
      ],
    ),
    const Habits(),
    const Text(
      'Znajomi',
      style: optionStyle,
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
