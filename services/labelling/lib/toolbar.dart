import 'package:flutter/material.dart';
import 'package:labelling/events/download.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToolBar extends StatefulWidget {
  final Function(DownloadEvent) downloadCallback;
  const ToolBar({Key? key, required this.downloadCallback}) : super(key: key);

  @override
  _ToolBarState createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  static const String _DEFAULT_INTERVAL = '30m';
  DateTimeRange? dateRange;
  String interval = _DEFAULT_INTERVAL;
  bool isSelectMode = false;

  @override
  void initState() {
    super.initState();
    loadStoredData();
  }

  void loadStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    final strDateFrom = prefs.getString('dateFrom');
    final strDateTo = prefs.getString('dateTo');
    setState(() {
      interval = prefs.getString('interval') ?? _DEFAULT_INTERVAL;
      dateRange = makeDatetimeRange(strDateFrom, strDateTo);
    });
  }

  DateTimeRange? makeDatetimeRange(String? strFrom, String? strTo) {
    if (strFrom == null || strTo == null) return null;
    final from = DateTime.parse(strFrom);
    final to = DateTime.parse(strTo);
    final datetimeRange = DateTimeRange(start: from, end: to);
    return datetimeRange;
  }

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
          onChanged: onInterval,
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

  void onSelectMode() {
    setState(() => isSelectMode = !isSelectMode);
  }

  void onCalendar() async {
    dateRange = await showDateRangePicker(
        context: context,
        initialDateRange: dateRange,
        firstDate: DateTime(2018),
        lastDate: DateTime.now().add(const Duration(days: 2)));
    downloadIfReady();
  }

  void onInterval(String? interval) {
    if (interval == null) return;
    setState(() {
      this.interval = interval;
    });
    downloadIfReady();
  }

  void downloadIfReady() async {
    await saveParam();
    if (dateRange == null) return;
    emitDownloadEvent();
  }

  Future<void> saveParam() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('interval', interval);
    if (dateRange != null) {
      prefs.setString('dateFrom', dateRange!.start.toString());
      prefs.setString('dateTo', dateRange!.end.toString());
    }
    return Future<void>.value();
  }

  void emitDownloadEvent() {
    if (dateRange == null) return;
    final event = DownloadEvent(dateRange!, interval);
    widget.downloadCallback(event);
  }
}
