import 'package:YoNunca/src/app_state.dart';
import 'package:YoNunca/src/bloc/bloc_provider.dart';
import 'package:YoNunca/src/yo_nunca_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  final blocProvider = BlocProvider();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(AppStateContainer(child: YoNuncaApp(), blocProvider: blocProvider));
}
