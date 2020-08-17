import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';



class DebugPage extends StatefulWidget {
  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  var headers;
 @override
  void initState() async {

    await _login();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final body = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Center(child :Text("Home Page"))
      ),
      body:  SingleChildScrollView(child: Html(data: body))
    );
  }

   _login() async {

  }
}