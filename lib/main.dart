import 'package:VRssage/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'list_video_example/list_video_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  // Than we setup preferred orientations,
  // and only after it finished we run our app

  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]).then((value) => runApp(const MyApp()));
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

        primarySwatch: Colors.blue,
      ),
      home: Splash(),
    );
  }
}
