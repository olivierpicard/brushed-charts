import 'package:flutter/material.dart';
import 'package:labelling/toolbar/download_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarWidget extends StatelessWidget {
  final void Function() onUpdate;
  final DownloadInfo data;
  const CalendarWidget({required this.data, required this.onUpdate, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _loadPref();
    return IconButton(
      onPressed: () => _onCalendar(context),
      iconSize: 30,
      icon: Icon(
        Icons.calendar_today_sharp,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _loadPref() async {
    final prefs = await SharedPreferences.getInstance();
    final strDateFrom = prefs.getString('dateFrom');
    final strDateTo = prefs.getString('dateTo');
    data.dateRange = _makeDatetimeRange(strDateFrom, strDateTo);
  }

  DateTimeRange? _makeDatetimeRange(String? strFrom, String? strTo) {
    if (strFrom == null || strTo == null) return null;
    final from = DateTime.parse(strFrom);
    final to = DateTime.parse(strTo);
    final datetimeRange = DateTimeRange(start: from, end: to);
    return datetimeRange;
  }

  void _onCalendar(BuildContext context) async {
    data.dateRange = await showDateRangePicker(
        context: context,
        initialDateRange: data.dateRange,
        firstDate: DateTime(2018),
        lastDate: DateTime.now());
    await _savePref();
  }

  Future<void> _savePref() async {
    if (data.dateRange?.start == null || data.dateRange?.end == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dateFrom', data.dateRange!.start.toIso8601String());
    await prefs.setString('dateTo', data.dateRange!.end.toIso8601String());
  }
}
