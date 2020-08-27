import 'package:flutter/material.dart';

class AsyncRaisedButton extends StatefulWidget {
  final Function onPressed;
  final Widget child;

  final Color color;
  final Color disabledColor;
  final Color textColor;

  final double elevation;
  final ShapeBorder shape;

  AsyncRaisedButton({
    Key key,
    @required this.onPressed,
    this.child,
    this.color,
    this.disabledColor,
    this.elevation,
    this.shape,
    this.textColor,
  }) : super(key: key);

  @override
  _AsyncButtonState createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncRaisedButton> {
  bool block = false;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: block
          ? null
          : () async {
              setState(() {
                block = true;
              });
              await widget.onPressed.call();
              try {
                setState(() {
                  block = false;
                });
              } catch (e) {
                print("AsyncButton: Left Context");
              }
            },
      textColor: widget.textColor,
      color: widget.color,
      child: widget.child,
      disabledColor: widget.disabledColor,
      elevation: widget.elevation,
      shape: widget.shape,
    );
  }
}
