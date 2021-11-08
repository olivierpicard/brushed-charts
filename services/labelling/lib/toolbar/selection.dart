import 'package:flutter/material.dart';
import 'package:labelling/toolbar.dart';

class SelectionMode extends StatelessWidget {
  const SelectionMode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => onSelectMode(context),
        iconSize: 30,
        icon: Icon(
          Icons.touch_app_sharp,
          color: getIconColor(context),
        ));
  }

  void onSelectMode(BuildContext context) {
    final toolBar = ToolBar.of(context)!;
    toolBar.update(() => toolBar.isSelected = !toolBar.isSelected);
  }

  Color getIconColor(BuildContext context) {
    bool isSelected = ToolBar.of(context)!.isSelected;
    print(isSelected);
    return isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).disabledColor;
  }
}
