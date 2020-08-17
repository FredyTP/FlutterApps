import 'package:flutter/material.dart';
import 'package:testfirebase/0villa/old/list_page.dart';
import 'package:testfirebase/0villa/old/start_page.dart';

import 'game_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int game = 0;

  void setGame(int n) {
    game = n;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (game == 0)
      return StartPage(beginGame: setGame);
    else if (game == 1)
      return ListPage();
    else
      return GamePage();
  }
}
