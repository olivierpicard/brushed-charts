import 'package:flutter/material.dart';

class SourceService extends ChangeNotifier {
  static const defaultRawSource = 'OANDA:EUR_USD';
  static const defaultInterval = '30m';
  static final defaultTimeRange = DateTimeRange(
      start: DateTime.now().toUtc().subtract(const Duration(days: 3)),
      end: DateTime.now().toUtc());

  DateTimeRange? dateRange;
  String? interval, rawSource;

  SourceService();

  SourceService.copy(SourceService original)
      : dateRange = original.dateRange,
        interval = original.interval,
        rawSource = original.rawSource;

  void update() {
    if (!isValid()) return;
    notifyListeners();
  }

  String? get broker => rawSource?.split(':')[0].toLowerCase();
  String? get asset => rawSource?.split(':')[1].toLowerCase();
  String? get dateFrom => dateRange?.start.toIso8601String().split('.')[0];
  String? get dateTo => dateRange?.end.toIso8601String().split('.')[0];

  int? get intervalToSeconds {
    if (interval == null) return null;
    final number = int.parse(interval!.substring(0, interval!.length - 1));
    final unit = interval![interval!.length - 1];
    switch (unit) {
      case 's':
        return number;
      case 'm':
        return number * 60;
      case 'h':
        return number * 60 * 60;
      case 'd':
        return number * 24 * 60 * 60;
      case 'w':
        return number * 7 * 24 * 60 * 60;
      case 'M':
        return number * 730 * 60 * 60;
      case 'y':
        return number * 8760 * 60 * 60;
      default:
        throw Exception('Interval has not the right syntax ($interval)');
    }
  }

  bool isValid() {
    if (rawSource == null || rawSource!.isEmpty) return false;
    if (!rawSource!.contains(':')) return false;
    if (dateRange == null) return false;
    if (interval == null || interval!.isEmpty) return false;
    return true;
  }
}
