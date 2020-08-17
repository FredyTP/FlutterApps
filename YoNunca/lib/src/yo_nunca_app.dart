import 'package:YoNunca/src/pages/game/game_page.dart';
import 'package:YoNunca/src/pages/home_page.dart';
import 'package:YoNunca/src/pages/game/list_page.dart';

import 'package:YoNunca/src/pages/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_stream_wrapper.dart';

class YoNuncaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yo Nunca 0Villa',
      initialRoute: "Home",
      debugShowCheckedModeBanner: false,
      //This takes the login apart from the Navigator stack and enable auto SignOut :)
      builder: (context, child) => LoginStreamWrapper(child: child),
      theme: ThemeData(
        primaryColor: Color.fromRGBO(30, 30, 30, 1),
        primaryColorDark: Color.fromRGBO(60, 60, 60, 1),
        accentColor: Colors.blue,
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
        primaryTextTheme: textTheme(),
      ),
      routes: {
        "Home": (BuildContext context) => HomePage(),
        "RandomGame": (BuildContext context) => GamePage(),
        "ListYoNunca": (BuildContext context) => ListPage(),
        "Login": (BuildContext context) => SignInPage(),
      },
    );
  }
}

TextTheme textTheme() {
  return TextTheme(
    headline1: GoogleFonts.bitter(fontSize: 95, fontWeight: FontWeight.w300, letterSpacing: -1.5),
    headline2: GoogleFonts.bitter(fontSize: 59, fontWeight: FontWeight.w300, letterSpacing: -0.5),
    headline3: GoogleFonts.bitter(fontSize: 48, fontWeight: FontWeight.w400),
    headline4: GoogleFonts.bitter(fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    headline5: GoogleFonts.bitter(fontSize: 24, fontWeight: FontWeight.w400),
    headline6: GoogleFonts.bitter(fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 0.15),
    subtitle1: GoogleFonts.bitter(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
    subtitle2: GoogleFonts.bitter(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    bodyText1: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
    bodyText2: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    button: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
    caption: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
    overline: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
  );
}
