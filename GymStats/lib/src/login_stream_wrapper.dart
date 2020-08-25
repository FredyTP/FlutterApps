import 'package:GymStats/src/pages/exercises_page.dart';
import 'package:GymStats/src/pages/home_page.dart';
import 'package:GymStats/src/pages/training/training_page.dart';
import 'package:GymStats/src/pages/trainings_list_page.dart';
import 'package:GymStats/src/pages/workout_template_list_page.dart';
import 'package:flutter/material.dart';

import 'app_state.dart';
import 'model/app_user_event.dart';
import 'pages/create_workout_page.dart';
import 'signin_page.dart';

class LoginStreamWrapper extends StatefulWidget {
  const LoginStreamWrapper({Key key}) : super(key: key);

  @override
  _LoginStreamWrapperState createState() => _LoginStreamWrapperState();
}

class _LoginStreamWrapperState extends State<LoginStreamWrapper> {
  final routes = {
    HomePage.route: (BuildContext context) => HomePage(),
    ExercisesPage.route: (BuildContext context) => ExercisesPage(),
    CreateWorkoutPage.route: (BuildContext context) => CreateWorkoutPage(),
    WorkoutListPage.route: (BuildContext context) => WorkoutListPage(),
    TrainingPage.route: (BuildContext context) => TrainingPage(),
    TrainingsListPage.route: (BuildContext context) => TrainingsListPage(),
  };

  final _navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider.appUserBloc;
    print("From Login Wrapper: ");
    print(bloc.currentUser?.userData?.userName);

    return StreamBuilder(
      stream: bloc.userEventStream,
      builder: (BuildContext context, AsyncSnapshot<AppUserEvent> snapshot) {
        //todo: fix this, should wait not show siginpage if already logged
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          print(snapshot.data.event);
          if (snapshot.data.event == UserEventType.kDisconnected) {
            return SignInPage();
          } else {
            return WillPopScope(
              onWillPop: () async {
                return !await _navigatorKey.currentState.maybePop();
              },
              child: Navigator(
                key: _navigatorKey,
                initialRoute: HomePage.route,
                onGenerateRoute: (settings) {
                  if (routes.containsKey(settings.name)) {
                    return MaterialPageRoute(builder: routes[settings.name]);
                  } else {
                    return MaterialPageRoute(builder: routes[HomePage.route]);
                  }
                },
              ),
            );
          }
        }
      },
    );
  }
}
