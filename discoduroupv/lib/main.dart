import 'package:discoduroupv/pages/debug_page.dart';
import 'package:flutter/material.dart';
import 'package:discoduroupv/bloc/provider.dart';

import 'package:discoduroupv/pages/home_page.dart';
import 'package:discoduroupv/pages/login_page.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) =>LoginPage(),
          'home' : (BuildContext context) =>HomePage(),
          'debug' : (BuildContext context) => DebugPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
        ),
      ) 
    );
  }
}