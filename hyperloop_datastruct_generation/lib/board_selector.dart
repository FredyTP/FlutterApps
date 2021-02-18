import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hyperloop_datastruct_generation/Model/BoardModel.dart';
import 'package:hyperloop_datastruct_generation/color_data.dart';
import 'package:hyperloop_datastruct_generation/file_manager.dart';
import 'package:reorderables/reorderables.dart';

import 'Model/Boards.dart';

import 'custom_popup_divider.dart';

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
    selectedBoard = widget.boards?.boardlist?.first ?? null;
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
                  children: editTextBoard == null
                      ? [
                          ReorderableColumn(
                            scrollController: ScrollController(),
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                final moved = widget.boards.boardlist.removeAt(oldIndex);
                                widget.boards.boardlist.insert(newIndex, moved);
                              });
                            },
                            children: buildBoardWidgetList(context),
                          )
                        ]
                      : buildBoardWidgetList(context)),
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
    selectBoard(model);
    editTextBoard = model;
    setState(() => widget.boards.add(model));
  }

  void deleteBoard(BoardModel board) {
    if (selectedBoard == board) {
      selectBoard(widget.boards.boardlist.first);
    }
    setState(() => widget.boards.remove(board));
    if (widget.boards.boardlist.isEmpty) {
      selectBoard(null);
    }
  }

  void deleteBoardCallback(BuildContext context, BoardModel board) async {
    if (board.data.size() > 0 || board.data.maxDepth() > 1) {
      final shouldDelete = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: deleteDialogBGColor,
                content: Text(
                  "You are going to delete ${board.name} and all its content (${board.data.numVariables()} elements).\n Do you want to continue?",
                  style: TextStyle(color: deleteDialogFontColor),
                ),
                title: Text(
                  "Delete Board",
                  style: TextStyle(color: deleteDialogFontColor),
                ),
                elevation: 10,
                actions: [
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Delete", style: TextStyle(color: deleteDialogFontColor, fontSize: 17)),
                    ),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Cancel", style: TextStyle(color: deleteDialogFontColor, fontSize: 17)),
                    ),
                  )
                ],
              );
            },
          ) ??
          false;
      if (shouldDelete) {
        setState(() {
          deleteBoard(board);
        });
      }
    } else {
      setState(() {
        deleteBoard(board);
      });
    }
  }

  buildBoardWidgetList(BuildContext context) {
    return widget.boards.boardlist.map((e) => buildBoardWidget(context, e)).toList();
  }

  Future<String> _showPopupMenu(BuildContext context, Offset offset, BoardModel board) async {
    final textStyle = TextStyle(fontSize: 16, color: Color.fromRGBO(230, 230, 230, 1.0), fontFamily: GoogleFonts.robotoSlab().fontFamily);
    final titleTextStyle = TextStyle(fontSize: 19, color: Color.fromRGBO(255, 255, 255, 1.0), fontFamily: GoogleFonts.robotoSlab().fontFamily);
    final deleteTextStyle = TextStyle(fontSize: 16, color: Colors.red, fontFamily: GoogleFonts.robotoSlab().fontFamily, fontWeight: FontWeight.bold);
    final barcolor = Color.fromRGBO(150, 150, 150, 1.0);
    final popupDivider = CustomPopupMenuDivider(
      height: 3,
      indent: 10,
      endIndent: 10,
      color: barcolor,
    );
    return await showMenu(
      color: ColorData.bgColor,
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, double.infinity, double.infinity),
      items: <PopupMenuEntry<String>>[
        PopUpMenuChild(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            child: Text(
              board.name,
              textAlign: TextAlign.center,
              style: titleTextStyle,
            ),
          ),
        ),
        popupDivider,
        PopupMenuItem<String>(child: Text('Change Name'), textStyle: textStyle, value: 'name'),
        popupDivider,
        PopupMenuItem<String>(child: Text('Import Struct'), textStyle: textStyle, value: 'import'),
        PopupMenuItem<String>(child: Text('Export Struct'), textStyle: textStyle, value: 'export'),
        popupDivider,
        PopupMenuItem<String>(child: Text('Delete Board'), textStyle: deleteTextStyle, value: 'delete'),
      ],
      elevation: 8.0,
    );
  }

  Widget buildBoardWidget(BuildContext context, BoardModel e) {
    if (e == editTextBoard) {
      return roundedContainer(
        key: ValueKey(e.hashCode),
        child: TextFormField(
          key: ValueKey(e.name),
          initialValue: e.name ?? "NewBoard",
          autofocus: true,
          onChanged: (value) {
            setState(() {
              e.name = value;
            });
          },
          onEditingComplete: () {
            selectBoard(selectedBoard); //This is just to update all widgets
            unSelect();
          },
          style: TextStyle(color: nameFontColor, fontSize: 20),
        ),
        color: selectedBoard == e ? Colors.red : structTypeColor,
        borderColor: nameFontColor,
      );
    }
    return GestureDetector(
      key: ValueKey(e.hashCode),
      onSecondaryTapDown: (TapDownDetails details) {
        _showPopupMenu(context, details.globalPosition, e).then((value) {
          if (value == "name") {
            setState(() {
              editTextBoard = e;
              initialName = e.name;
            });
          } else if (value == "import") {
            widget.fileManager.importDataStructure(e).then((value) => setState(() {}));
          } else if (value == "export") {
            widget.fileManager.exportDataStructure(e);
          } else if (value == "code") {
            if (widget.fileManager.isOpen) {
              saveGeneratedCode(widget.fileManager.project.file.parent.path, e);
            } else {
              widget.fileManager.saveProject().then((value) => value == 0 ? saveGeneratedCode(widget.fileManager.project.file.parent.path, e) : 0);
            }
          } else if (value == "delete") {
            deleteBoardCallback(context, e);
          }
        });
      },
      onTap: () => selectBoard(e),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: roundedContainer(
          child: Text(
            e.name,
            style: TextStyle(color: nameFontColor, fontSize: 20),
          ),
          color: selectedBoard == e ? Colors.red : structTypeColor,
          borderColor: nameFontColor,
        ),
      ),
    );
  }

  void saveGeneratedCode(String folder, BoardModel board) async {
    /*File file = File("$folder\\${board.name}_${board.data.headnode.name}_generated.js");
    final codeGen = TSCodeGenerator();
    await file.writeAsString(codeGen.generateCode(board.data.headnode));
    File filec = File("$folder\\${board.name}_${board.data.headnode.name}_generated.h");
    await filec.writeAsString(generateCCode(board.data.headnode));*/
  }

  void selectBoard(BoardModel model) {
    unSelect();
    widget.selectBoard(model);
    setState(() {
      selectedBoard = model;
    });
  }

  Widget roundedContainer({Key key, Widget child, Color color, Color borderColor = Colors.black, bool border = true}) {
    return Container(
      key: key,
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      margin: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: child,
      decoration: BoxDecoration(border: border ? Border.all(color: borderColor) : null, borderRadius: BorderRadius.circular(10), color: color),
      alignment: Alignment.center,
    );
  }
}
