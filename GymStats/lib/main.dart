import 'package:GymStats/src/app_state.dart';
import 'package:GymStats/src/bloc/bloc_provider.dart';
import 'package:GymStats/src/gym_stats_app.dart';
import 'package:flutter/material.dart';

void main() {
  final blocProvider = BlocProvider();
  runApp(AppStateContainer(
    child: GymStatsApp(),
    blocProvider: blocProvider,
  ));
}
