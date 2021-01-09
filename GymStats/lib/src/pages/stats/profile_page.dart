import 'package:GymStats/src/app_state.dart';
import 'package:GymStats/src/model/data/profile_data.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  static const String route = "ProfilePage";
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    return Container(
      child: Column(
        children: [
          StreamBuilder<ProfileData>(
              stream: bloc.trainingBloc.getProfileDataStream(bloc.appUserBloc.currentUser.userData.id),
              builder: (context, snapshot) {
                print("data: ");
                print(snapshot.data);
                if (snapshot.hasData)
                  return _createProfileInfo(snapshot.data);
                else {
                  return LinearProgressIndicator();
                }
              }),
        ],
      ),
    );
  }

  Widget _createProfileInfo(ProfileData data) {
    return Container(
      //color: Colors.blue,
      decoration: BoxDecoration(
        color: Color.fromRGBO(230, 230, 230, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 93,
      padding: EdgeInsets.fromLTRB(7, 10, 7, 7),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: AutoSizeText(
              "Level",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 23, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 17,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _createInfoItem(top: data.totalTrainings.toString(), bot: "Sesiones"),
                _createInfoItem(top: data.totalWeight.toString() + " kg", bot: "Peso"),
                _createInfoItem(top: data.totalReps.toString(), bot: "Reps"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _createInfoItem({String top, @required String bot, Widget topWidget}) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7),
        //color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            top != null
                ? AutoSizeText(
                    top,
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
                : topWidget,
            SizedBox(
              height: 7,
            ),
            AutoSizeText(
              bot,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
