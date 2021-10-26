import 'package:flutter/material.dart';

class ToolBar extends StatefulWidget {
  final double textFieldLength = 100;
  const ToolBar({Key? key}) : super(key: key);

  @override
  _ToolBarState createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  DateTimeRange? dateRange;
  String interval = '30m';
  bool isSelectMode = false;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(width: 30),
      IconButton(
        onPressed: onSelectMode,
        iconSize: 30,
        icon: Icon(
          Icons.touch_app_sharp,
          color: isSelectMode
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).disabledColor,
        ),
      ),
      const SizedBox(width: 30),
      IconButton(
        onPressed: onCalendar,
        iconSize: 30,
        icon: Icon(
          Icons.calendar_today_sharp,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      const SizedBox(width: 30),
      DropdownButton(
          onChanged: (e) => {},
          value: interval,
          items: <String>[
            '1s',
            '2s',
            '5s',
            '1m',
            '2m',
            '5m',
            '10m',
            '15m',
            '30m',
            '45m',
            '1h',
            '2h',
            '4h',
            '1d',
            '1w',
            '1M',
            '1y'
          ]
              .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
              .toList())
    ]);
  }

  void onCalendar() async {
    dateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2018),
        lastDate: DateTime.now().add(const Duration(days: 2)));
  }

  void onInterval() {}
  void onSelectMode() {
    setState(() => isSelectMode = !isSelectMode);
  }
}
