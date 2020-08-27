import 'package:GymStats/src/login_stream_wrapper.dart';
import 'package:flutter/material.dart';

class GymStatsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Stats',
      home: LoginStreamWrapper(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black, brightness: Brightness.dark),
    );
  }
}
