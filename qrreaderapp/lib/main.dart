import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/pages/maps_page.dart';
import 'src/pages/home_page.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Reader',
      initialRoute: 'home',
      routes: {
        'home' : (BuildContext context) => HomePage(),
        'maps' : (BuildContext context) => MapsPage()
      },
      theme: ThemeData(
        primaryColor: Colors.pinkAccent,
      ),
    );
  }
}