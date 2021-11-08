import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarWidget extends StatefulWidget {
  final void Function() onUpdate;
  const CalendarWidget({required this.onUpdate, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CalendarWidget();
}

class _CalendarWidget extends State<CalendarWidget> {
  DateTimeRange? dateRange;

  @override
  void initState() {
    super.initState();
    _loadPref();
  }

  void _loadPref() async {
    final prefs = await SharedPreferences.getInstance();
    final strDateFrom = prefs.getString('dateFrom');
    final strDateTo = prefs.getString('dateTo');
    dateRange = _makeDatetimeRange(strDateFrom, strDateTo);
  }

  DateTimeRange? _makeDatetimeRange(String? strFrom, String? strTo) {
    if (strFrom == null || strTo == null) return null;
    final from = DateTime.parse(strFrom);
    final to = DateTime.parse(strTo);
    final datetimeRange = DateTimeRange(start: from, end: to);
    return datetimeRange;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _onCalendar,
      iconSize: 30,
      icon: Icon(
        Icons.calendar_today_sharp,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _onCalendar() async {
    dateRange = await showDateRangePicker(
        context: context,
        initialDateRange: dateRange,
        firstDate: DateTime(2018),
        lastDate: DateTime.now());
    _savePref();
    widget.onUpdate();
  }

  Future<void> _savePref() async {
    if (dateRange?.start == null || dateRange?.end == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dateFrom', dateRange!.start.toIso8601String());
    await prefs.setString('dateTo', dateRange!.end.toIso8601String());
  }
}
