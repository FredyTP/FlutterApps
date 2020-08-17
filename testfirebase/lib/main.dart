import 'package:flutter/material.dart';
import 'package:testfirebase/0villa/app_state.dart';
import 'package:testfirebase/0villa/bloc/bloc_provider.dart';
import 'package:testfirebase/0villa/yo_nunca_app.dart';

void main() {
  final blocProvider = BlocProvider();
  runApp(AppStateContainer(
    child: YoNuncaApp(),
    blocProvider: blocProvider,
  ));
}
