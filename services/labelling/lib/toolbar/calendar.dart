import 'package:flutter/material.dart';
import 'package:labelling/services/source.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarWidget extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  CalendarWidget({Key? key}) : super(key: key);

  late final SourceService source;

  @override
  Widget build(BuildContext context) {
    source = context.read<SourceService>();
    _loadPref();
    return IconButton(
      onPressed: () => _onCalendar(context),
      iconSize: 25,
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
    source.dateRange = _makeDatetimeRange(strDateFrom, strDateTo);
    source.update();
  }

  DateTimeRange _makeDatetimeRange(String? strFrom, String? strTo) {
    if (strFrom == null || strTo == null) return SourceService.defaultTimeRange;
    if (strFrom == '' || strTo == '') return SourceService.defaultTimeRange;
    final from = DateTime.parse(strFrom);
    final to = DateTime.parse(strTo);
    final datetimeRange = DateTimeRange(start: from, end: to);
    return datetimeRange;
  }

  void _onCalendar(BuildContext context) async {
    final range = await showDateRangePicker(
        context: context,
        initialDateRange: source.dateRange,
        firstDate: DateTime(2018),
        lastDate: DateTime.now());
    saveIfDateIsCorrect(range);
  }

  void saveIfDateIsCorrect(DateTimeRange? range) {
    if (range == null) return;
    source.dateRange = range;
    source.update();
    _savePref();
  }

  Future<void> _savePref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'dateFrom', source.dateRange?.start.toIso8601String() ?? '');
    await prefs.setString(
        'dateTo', source.dateRange?.end.toIso8601String() ?? '');
  }
}
