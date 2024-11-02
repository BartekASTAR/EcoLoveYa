import 'dart:async';
import 'package:datetime_setting/datetime_setting.dart';
import 'package:eco_life/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

  //TODO : Sprawdzić jak to wpływa na działanie aplikacji
  var period = const Duration(seconds:2);
  Timer.periodic(period,(arg){
    CheckDateSettings();
  });
}

void CheckDateSettings() async {
  bool timeAuto = await DatetimeSetting.timeIsAuto();
  bool timezoneAuto = await DatetimeSetting.timeZoneIsAuto();

  if (!timezoneAuto || !timeAuto) {
    DatetimeSetting.openSetting();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}


