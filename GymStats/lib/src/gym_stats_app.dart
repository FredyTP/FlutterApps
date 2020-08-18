import 'package:GymStats/src/pages/exercises_page.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';

class GymStatsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Stats',
      initialRoute: "exercises",
      debugShowCheckedModeBanner: false,
      routes: {
        "home": (BuildContext context) => HomePage(),
        "exercises": (BuildContext context) => ExercisesPage(),
      },
    );
  }
}
