import 'package:flutter/material.dart';
import 'package:hyperloop_datastruct_generation/Model/BoardModel.dart';

import 'Model/Boards.dart';

class BoardSelector extends StatefulWidget {
  final Boards boards;
  final bool show;
  final void Function(BoardModel) selectBoard;
  BoardSelector({Key key, this.boards, this.show = true, this.selectBoard}) : super(key: key);

  @override
  _BoardSelectorState createState() => _BoardSelectorState();
}

class _BoardSelectorState extends State<BoardSelector> {
  BoardModel selectedBoard;
  //-------COLORS----------//
  final Color varTypeColor = Color.fromRGBO(170, 78, 47, 1.0);
  final Color structTypeColor = Color.fromRGBO(71, 74, 117, 1.0);
  final Color varNameColor = Color.fromRGBO(163, 163, 184, 1.0);
  final Color lenColor = Color.fromRGBO(218, 218, 226, 1.0);
  final Color deleteDialogBGColor = Color.fromRGBO(50, 50, 60, 0.95);
  final Color deleteDialogFontColor = Color.fromRGBO(220, 220, 220, 1);
  final Color nameFontColor = Color.fromRGBO(230, 230, 232, 1);
  final Color boxColor = Color.fromRGBO(50, 50, 65, 1);
  final Color dropdownArrowColor = Color.fromRGBO(163, 163, 184, 1.0);
  final Color drawerBG = Color.fromRGBO(20, 20, 25, 1);

  @override
  void initState() {
    super.initState();
    selectedBoard = widget.boards.boardlist.first;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.show)
      return Container(
        padding: EdgeInsets.all(5),
        color: drawerBG,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/img/Avionics_degradado.png",
              isAntiAlias: true,
            ),
            Text(
              "BOARDS",
              style: TextStyle(color: nameFontColor, fontSize: 20),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              thickness: 0,
              color: nameFontColor,
            ),
            Expanded(
              child: ListView(
                children: buildBoardWidgetList(),
              ),
            ),
            FlatButton(
              minWidth: 200,
              onPressed: () => addNewBoard(BoardModel(name: "NAVIGATION")),
              child: Icon(Icons.add),
              color: Colors.green,
            )
          ],
        ),
      );
    else
      return SizedBox.shrink();
  }

  void addNewBoard(BoardModel model) {
    setState(() => widget.boards.add(model));
  }

  void deleteBoard(BoardModel model) {
    widget.boards.remove(model);
  }

  buildBoardWidgetList() {
    return widget.boards.boardlist.map((e) => buildBoardWidget(e)).toList();
  }

  Widget buildBoardWidget(BoardModel e) {
    return GestureDetector(
      onTap: () => selectBoard(e),
      child: roundedContainer(
        child: Text(
          e.name,
          style: TextStyle(color: nameFontColor, fontSize: 20),
        ),
        color: selectedBoard == e ? Colors.red : structTypeColor,
        borderColor: nameFontColor,
      ),
    );
  }

  void selectBoard(BoardModel model) {
    widget.selectBoard(model);
    setState(() {
      selectedBoard = model;
    });
  }

  Widget roundedContainer({Widget child, Color color, Color borderColor = Colors.black, bool border = true}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      margin: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: child,
      decoration: BoxDecoration(border: border ? Border.all(color: borderColor) : null, borderRadius: BorderRadius.circular(10), color: color),
      alignment: Alignment.center,
    );
  }
}
