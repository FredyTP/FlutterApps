import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  TestPage({Key key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) {
          print(details.localPosition);
          print(details.globalPosition);
        },
        child: Container(
          color: Colors.pink,
          constraints: BoxConstraints.expand(),
          child: Stack(
            children: [_createPage(top: 100, left: 100, color: Colors.red), _createPage(top: 500, left: 150, color: Colors.green)],
          ),
        ),
      ),
    );
  }

  Widget _createPage({num top, num left, Color color}) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        color: color,
        width: 100,
        height: 100,
      ),
    );
  }
}
