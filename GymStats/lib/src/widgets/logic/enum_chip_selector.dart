import 'package:flutter/material.dart';

class EnumChipSelector<ET> extends StatefulWidget {
  final bool Function(ET) isSelected;
  final void Function(List<ET>) onChange;
  final String title;
  final List<ET> enumeration;
  final List<ET> initialData;
  EnumChipSelector({Key key, this.isSelected, this.onChange, this.title, this.enumeration, this.initialData}) : super(key: key);

  @override
  _EnumChipSelectorState<ET> createState() => _EnumChipSelectorState<ET>();
}

class _EnumChipSelectorState<ET> extends State<EnumChipSelector<ET>> {
  final List<ET> lista = [];
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      widget.initialData.forEach((element) {
        lista.add(element);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(10),
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 20),
              )),
          ExpansionPanelList(
            expandedHeaderPadding: EdgeInsets.all(0),
            expansionCallback: (panelIndex, expand) {
              setState(() {
                isExpanded = !expand;
              });
            },
            children: [
              ExpansionPanel(
                isExpanded: isExpanded,
                headerBuilder: (context, isExpanded) {
                  return Container(
                    padding: EdgeInsets.all(7),
                    alignment: Alignment.center,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: lista
                              ?.map((e) => Chip(
                                    deleteIcon: Transform.rotate(angle: 45 * 3.1415 / 180, child: Icon(Icons.add_circle)),
                                    onDeleted: () {
                                      setState(() {
                                        lista.remove(e);
                                      });
                                      widget.onChange(lista);
                                    },
                                    label: Text(e.toString().split('.').last),
                                  ))
                              ?.toList() ??
                          [Container()],
                    ),
                  );
                },
                body: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(7),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [Divider()]..addAll(
                        widget.enumeration.map(
                          (e) {
                            return ((widget.isSelected?.call(e) ?? lista.contains(e)) == false)
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if ((widget.isSelected?.call(e) ?? lista.contains(e)) == false) lista.add(e);
                                      });
                                      widget.onChange(lista);
                                    },
                                    child: Chip(
                                      backgroundColor: Color.fromRGBO(50, 230, 100, 1),
                                      label: Text(e.toString().split('.').last),
                                    ),
                                  )
                                : SizedBox.shrink();
                          },
                        ),
                      ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
