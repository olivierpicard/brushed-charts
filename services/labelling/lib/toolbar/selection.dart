import 'package:flutter/material.dart';

class SelectionMode extends StatefulWidget {
  final void Function(bool) onSelect;

  const SelectionMode({required this.onSelect, Key? key}) : super(key: key);

  @override
  _SelectionModeState createState() => _SelectionModeState();
}

class _SelectionModeState extends State<SelectionMode> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => _onButtonPressed(context),
        iconSize: 30,
        icon: Icon(
          Icons.touch_app_sharp,
          color: _getIconColor(context),
        ));
  }

  void _onButtonPressed(BuildContext context) {
    setState(() => isSelected = !isSelected);
    widget.onSelect(isSelected);
  }

  Color _getIconColor(BuildContext context) {
    return isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).disabledColor;
  }
}
