import 'dart:async';

import 'package:datetime_setting/datetime_setting.dart';
import 'package:eco_life/data_provider.dart';
import 'package:eco_life/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => DataProvider()),
  ], child: MyApp()));

  //TODO : Sprawdzić jak to wpływa na działanie aplikacji
  var period = const Duration(seconds: 2);
  Timer.periodic(period, (arg) {
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: context.watch<DataProvider>().isDarkTheme
          ? ThemeData.dark()
          : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
