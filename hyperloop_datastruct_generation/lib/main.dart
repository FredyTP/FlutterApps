//                   GNU GENERAL PUBLIC LICENSE
//                    Version 3, 29 June 2007

//Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
//Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.
//Author: Alfredo Torres Pons

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hyperloop_datastruct_generation/home_page.dart';

//import 'package:win32/win32.dart';

void main() {
  //int window = GetForegroundWindow();
  //SetWindowText(window, TEXT("HYPERLOOP-UPV DATA STRUCT GENERATOR - by Alfredo Torres"));
//
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HL DS Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColorDark: Color.fromRGBO(55, 55, 55, 1.0),
        //platform: TargetPlatform.windows,
        fontFamily: GoogleFonts.robotoSlab().fontFamily,
        appBarTheme: AppBarTheme(color: Color.fromRGBO(35, 35, 35, 1.0), centerTitle: false, systemOverlayStyle: SystemUiOverlayStyle.dark),
      ),
      home: HomePage(),
    );
  }
}
