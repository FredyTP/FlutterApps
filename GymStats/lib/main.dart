import 'package:GymStats/src/app_state.dart';
import 'package:GymStats/src/bloc/bloc_provider.dart';
import 'package:GymStats/src/gym_stats_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final blocProvider = BlocProvider();
  blocProvider.init();
  runApp(AppStateContainer(
    child: GymStatsApp(),
    blocProvider: blocProvider,
  ));
}
