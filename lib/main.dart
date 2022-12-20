import 'package:better_player_example/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VRssage',
      theme: ThemeData(

        primarySwatch: Colors.grey,
      ),
      home: Splash(),
    );
  }
}
