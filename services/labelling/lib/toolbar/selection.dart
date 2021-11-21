import 'package:flutter/material.dart';
import 'package:labelling/services/appmode.dart';
import 'package:labelling/services/source.dart';
import 'package:provider/provider.dart';

class SelectionMode extends StatefulWidget {
  const SelectionMode({Key? key}) : super(key: key);

  @override
  _SelectionModeState createState() => _SelectionModeState();
}

class _SelectionModeState extends State<SelectionMode> {
  bool isSelected = false;
  late final appMode = context.read<AppModeService>();

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
    appMode.mode = (isSelected) ? AppMode.selection : AppMode.free;
  }

  Color _getIconColor(BuildContext context) {
    return isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).disabledColor;
  }
}
