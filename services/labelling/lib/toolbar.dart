import 'package:flutter/material.dart';

class ToolBar extends StatefulWidget {
  final double textFieldLength = 100;
  const ToolBar({Key? key}) : super(key: key);

  @override
  _ToolBarState createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 20),
      IconButton(
        onPressed: () => {},
        iconSize: 30,
        icon: Icon(
          Icons.touch_app_sharp,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      Container(width: 40),
      Container(
        width: widget.textFieldLength,
        child: TextField(decoration: InputDecoration(hintText: "Start date")),
      ),
      Container(width: 20),
      Container(
        width: widget.textFieldLength,
        child: TextField(decoration: InputDecoration(hintText: "End date")),
      ),
    ]);
  }
}
