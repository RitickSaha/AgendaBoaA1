import 'package:agenda_boa_assignemnt/views/screen/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData dark = ThemeData.from(
      colorScheme: ColorScheme.dark(
          primary: const Color(0xFFFFFFFF),
          primaryVariant: const Color(0xFF000000),
          secondary: const Color(0xFF000000),
          secondaryVariant: const Color(0xFF000000),
          surface: const Color(0xFF000000),
          background: Colors.black,
          error: const Color(0xFFFF0000),
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onSurface: Colors.white,
          onBackground: Colors.white));
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Boa - Assignment 1',
      theme: dark,
      home: MyHomePage(title: 'Home'),
    );
  }
}

