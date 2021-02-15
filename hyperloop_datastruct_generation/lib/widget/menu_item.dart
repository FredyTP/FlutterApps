import 'package:flutter/material.dart';

enum MenuDirection {
  bottom,
  right,
}

class MenuItem extends StatefulWidget {
  const MenuItem({Key key, this.items, this.child, this.menuColor, this.crossAxisAligment = CrossAxisAlignment.start, this.direction = MenuDirection.bottom}) : super(key: key);
  final List<Widget> items;
  final Widget child;
  final Color menuColor;
  final MenuDirection direction;
  final CrossAxisAlignment crossAxisAligment;

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  Color color = Colors.red;
  @override
  Widget build(BuildContext context) {
    final bool hasItems = widget.items != null;
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          color = Colors.blue;
        });
        final RenderBox itemBox = context.findRenderObject() as RenderBox;
        final Rect itemRect = itemBox.localToGlobal(Offset.zero) & itemBox.size;

        if (hasItems) {
          Widget children;
          if (widget.direction == MenuDirection.bottom) {
            children = Positioned(
              left: itemRect.left,
              top: itemRect.top + itemRect.height,
              child: Container(
                color: widget.menuColor,
                child: Column(
                  crossAxisAlignment: widget.crossAxisAligment,
                  children: widget.items,
                ),
              ),
            );
          } else {
            children = Positioned(
              left: itemRect.left + itemRect.width,
              top: itemRect.top,
              child: Container(
                color: widget.menuColor,
                child: Row(
                  crossAxisAlignment: widget.crossAxisAligment,
                  children: widget.items,
                ),
              ),
            );
          }
          showDialog(
            barrierColor: Colors.transparent,
            context: context,
            builder: (context) {
              return Stack(children: [children]);
            },
          );
        }
      },
      onExit: (event) {
        setState(() {
          color = Colors.red;
        });
      },
      child: GestureDetector(
        child: Center(child: Container(child: widget.child)),
      ),
    );
  }
}
