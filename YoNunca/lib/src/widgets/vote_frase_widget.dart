import 'package:YoNunca/src/app_state.dart';
import 'package:YoNunca/src/bloc/frase_bloc.dart';
import 'package:YoNunca/src/models/frase_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VoteFraseWidget extends StatefulWidget {
  final DocumentSnapshot yoNunca;
  VoteFraseWidget({Key key, @required this.yoNunca}) : super(key: key);

  @override
  VoteFraseWidgetState createState() => VoteFraseWidgetState();
}

class VoteFraseWidgetState extends State<VoteFraseWidget> {
  bool _voted = false;
  bool _processingVote = false;
  int _voteIdx = 0;
  num _ratingResult = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              gradient: LinearGradient(colors: [Color.fromRGBO(190, 190, 255, 0.4), Color.fromRGBO(230, 230, 255, 0.4)]),
              boxShadow: [BoxShadow(color: Color.fromRGBO(50, 50, 50, 0.1), blurRadius: 5, offset: Offset(10, 15))],
            ),
            child: Text(_voted ? "La puntuación es: ${_ratingResult.toStringAsPrecision(3)}" : "Votar: "),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(colors: [Color.fromRGBO(190, 190, 255, 0.4), Color.fromRGBO(230, 230, 255, 0.4)]),
              boxShadow: [BoxShadow(color: Color.fromRGBO(50, 50, 50, 0.1), blurRadius: 5, offset: Offset(10, 15))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _createVoteList(context),
            ),
          )
        ],
      ),
    );
  }

  void resetVote() {
    _voted = false;
  }

  List<Widget> _createVoteList(BuildContext context) {
    final fraseBloc = AppStateContainer.of(context).blocProvider.fraseBloc;
    final list = List<Widget>();
    for (int i = 0; i < 5; i++) {
      list.add(_createVoteButton(context, i, fraseBloc));
    }
    return list;
  }

  Widget _createVoteButton(BuildContext context, int index, FraseBloc fraseBloc) {
    List<Color> colorList = [Colors.red, Colors.orange, Colors.yellow[700], Colors.green[300], Colors.green];
    final vote = (index) * 10 / (colorList.length - 1);
    final size = MediaQuery.of(context).size;
    final side = size.width / 9 - 8;
    return RawMaterialButton(
      shape: CircleBorder(),
      constraints: BoxConstraints.tight(Size(side, side)),
      elevation: 5,
      disabledElevation: 0,
      fillColor: (_voted || _processingVote) && _voteIdx != index ? Colors.grey : colorList[index],
      onPressed: (_voted || _processingVote)
          ? null
          : () {
              if (!_processingVote) {
                final frase = FraseModel.fromJson(widget.yoNunca.data);
                final acum = frase.rating * frase.votes;
                _ratingResult = (acum + vote) / (frase.votes + 1);
                fraseBloc.voteFrase(widget.yoNunca, vote).then((value) => setState(() => _processingVote = false));
              }

              setState(() {
                _processingVote = true;
                _voteIdx = index;
                _voted = true;
              });
            }, //bloc.voteFrase(vote, frase),
    );
  }
}
