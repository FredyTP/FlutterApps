import 'package:GymStats/src/app_state.dart';
import 'package:flutter/material.dart';

class ExerciseImage extends StatelessWidget {
  final String imgPath;
  final BoxFit fit;
  final Widget Function(BuildContext, Widget, ImageChunkEvent) loadingBuilder;

  const ExerciseImage({Key key, this.imgPath, this.fit, this.loadingBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    return FutureBuilder(
      future: bloc.storageBloc.getFileURL(imgPath),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.network(snapshot.data, fit: fit, loadingBuilder: loadingBuilder);
        } else {
          return Container();
        }
      },
    );
  }
}
