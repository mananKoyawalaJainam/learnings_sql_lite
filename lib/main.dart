import 'package:flutter/material.dart';
import 'package:sql_lite/screen/home_screen.dart';
import 'package:sql_lite/service/navigation_key.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
