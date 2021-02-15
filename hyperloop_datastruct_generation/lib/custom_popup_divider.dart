import 'package:flutter/material.dart';

class CustomPopupMenuDivider extends PopupMenuEntry<Never> {
  /// Creates a horizontal divider for a popup menu.
  ///
  /// By default, the divider has a height of 16 logical pixels.
  const CustomPopupMenuDivider({Key key, this.color = Colors.white, this.indent = 0, this.endIndent = 0, this.height = 0}) : super(key: key);

  /// The height of the divider entry.
  ///
  /// Defaults to 16 pixels.
  @override
  final double height;
  final double indent;
  final double endIndent;
  final Color color;

  @override
  bool represents(void value) => false;

  @override
  _CustomPopupMenuDividerState createState() => _CustomPopupMenuDividerState();
}

class _CustomPopupMenuDividerState extends State<CustomPopupMenuDivider> {
  @override
  Widget build(BuildContext context) => Divider(
        height: widget.height,
        indent: widget.indent,
        endIndent: widget.endIndent,
        color: widget.color,
      );
}

class PopUpMenuChild extends PopupMenuEntry<Never> {
  /// Creates a horizontal divider for a popup menu.
  ///
  /// By default, the divider has a height of 16 logical pixels.
  const PopUpMenuChild({Key key, this.child, this.height}) : super(key: key);

  /// The height of the divider entry.
  ///
  /// Defaults to 16 pixels.
  @override
  final double height;

  final Widget child;
  @override
  bool represents(void value) => false;

  @override
  _PopUpMenuChildState createState() => _PopUpMenuChildState();
}

class _PopUpMenuChildState extends State<PopUpMenuChild> {
  @override
  Widget build(BuildContext context) => widget.child;
}
