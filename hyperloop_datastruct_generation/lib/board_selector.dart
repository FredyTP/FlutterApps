import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hyperloop_datastruct_generation/Model/BoardModel.dart';
import 'package:hyperloop_datastruct_generation/file_manager.dart';

import 'Model/Boards.dart';

class BoardSelector extends StatefulWidget {
  final Boards boards;
  final bool show;
  final FileManager fileManager;
  final void Function(BoardModel) selectBoard;
  BoardSelector({Key key, this.boards, this.show = true, this.selectBoard, this.fileManager}) : super(key: key);

  @override
  BoardSelectorState createState() => BoardSelectorState();
}

class BoardSelectorState extends State<BoardSelector> {
  BoardModel selectedBoard;

  BoardModel editTextBoard;
  String initialName = "NewBoard";
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
                children: buildBoardWidgetList(context),
              ),
            ),
            FlatButton(
              minWidth: 200,
              onPressed: () => addNewBoard(BoardModel(name: "")),
              child: Icon(Icons.add),
              color: Colors.green,
            )
          ],
        ),
      );
    else
      return SizedBox.shrink();
  }

  void unSelect() {
    if (editTextBoard?.name == "") editTextBoard?.name = initialName;
    setState(() {
      editTextBoard = null;
      initialName = "NewBoard";
    });
  }

  void addNewBoard(BoardModel model) {
    editTextBoard = model;
    setState(() => widget.boards.add(model));
  }

  void deleteBoard(BoardModel model) {
    setState(() => widget.boards.remove(model));
  }

  buildBoardWidgetList(BuildContext context) {
    return widget.boards.boardlist.map((e) => buildBoardWidget(context, e)).toList();
  }

  Future<String> _showPopupMenu(BuildContext context, Offset offset, BoardModel board) async {
    return await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, double.infinity, double.infinity),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          child: Center(
            child: Text(
              board.name,
              textAlign: TextAlign.center,
            ),
          ),
          value: 'boardname',
          enabled: false,
        ),
        PopupMenuDivider(height: 0),
        PopupMenuItem<String>(child: Text('Change Name'), value: 'name'),
        PopupMenuItem<String>(child: Text('Import Struct'), value: 'import'),
        PopupMenuItem<String>(child: Text('Export Struct'), value: 'export'),
      ],
      elevation: 8.0,
    );
  }

  Widget buildBoardWidget(BuildContext context, BoardModel e) {
    if (e == editTextBoard) {
      return roundedContainer(
        child: TextFormField(
          initialValue: e.name ?? "NewBoard",
          autofocus: true,
          onChanged: (value) {
            setState(() {
              e.name = value;
            });
          },
          onEditingComplete: () {
            unSelect();
          },
          style: TextStyle(color: nameFontColor, fontSize: 20),
        ),
        color: selectedBoard == e ? Colors.red : structTypeColor,
        borderColor: nameFontColor,
      );
    }
    return GestureDetector(
      onSecondaryTapDown: (TapDownDetails details) {
        _showPopupMenu(context, details.globalPosition, e).then((value) {
          if (value == "name") {
            setState(() {
              editTextBoard = e;
              initialName = e.name;
            });
          } else if (value == "import") {
            widget.fileManager.importDataStructure(e).then((value) => setState(() {}));
          } else if (value == 'export') {
            widget.fileManager.exportDataStructure(e);
          }
        });
      },
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
    unSelect();
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
