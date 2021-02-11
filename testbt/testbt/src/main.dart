import 'package:flutter/material.dart';
import 'page/main_page.dart';

void main() => runApp(new TestBT());

class TestBT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
