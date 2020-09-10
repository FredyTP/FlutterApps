import 'package:GymStats/src/model/exercise_model.dart';
import 'package:GymStats/src/widgets/logic/exercise_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ExerciseGridCard extends StatelessWidget {
  final Function(BuildContext, ExerciseModel, Widget image) onSelect;
  final Function(BuildContext, ExerciseModel, Widget image) onLongPress;
  final double radius;
  final ExerciseModel exercise;
  final Color topBorderColor;
  final Color botBorderColor;
  final bool haveBorder;
  final Color footerColor;
  ExerciseGridCard({
    Key key,
    @required this.exercise,
    this.onSelect,
    this.onLongPress,
    this.radius = 15,
    this.topBorderColor = Colors.red,
    this.botBorderColor = const Color.fromRGBO(200, 200, 200, 1),
    this.haveBorder = true,
    this.footerColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = exercise.imagePath == null
        ? Container()
        : ExerciseImage(
            imgPath: exercise.imagePath,
            fit: BoxFit.fitWidth,
          );
    return GestureDetector(
      onTap: () {
        onSelect?.call(context, exercise, image);
      },
      onLongPress: () {
        onLongPress?.call(context, exercise, image);
      },
      child: Card(
        borderOnForeground: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(this.radius),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 7,
        color: topBorderColor,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: haveBorder ? 12 : 3,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color.fromRGBO(botBorderColor.red, botBorderColor.green, botBorderColor.blue, 0), botBorderColor],
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                    ),
                  ),
                  child: image,
                ),
              ),
              Expanded(
                flex: haveBorder ? 6 : 2,
                child: Container(
                  color: footerColor,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(7),
                  child: AutoSizeText(
                    exercise.name ?? "No Name",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
