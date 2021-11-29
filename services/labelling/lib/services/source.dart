import 'package:flutter/material.dart';

class SourceService extends ChangeNotifier {
  static const defaultRawSource = 'OANDA:EUR_USD';
  static const defaultInterval = '30m';
  static final defaultTimeRange = DateTimeRange(
      start: DateTime.now().toUtc().subtract(const Duration(days: 3)),
      end: DateTime.now().toUtc());

  DateTimeRange dateRange = defaultTimeRange;
  String interval = defaultInterval;
  String _rawSource = defaultRawSource;
  String _broker = defaultRawSource.split(':')[0];
  String _asset = defaultRawSource.split(':')[1];

  SourceService();

  SourceService.copy(SourceService original)
      : dateRange = original.dateRange,
        interval = original.interval,
        _rawSource = original._rawSource;

  void update() => notifyListeners();

  set rawSource(String val) {
    _rawSource = val;
    _broker = val.split(':')[0].toLowerCase();
    _asset = val.split(':')[1].toLowerCase();
  }

  String get rawSource => _rawSource;
  String get broker => _broker;
  String get asset => _asset;
  String get dateFrom => dateRange.start.toIso8601String().split('.')[0];
  String get dateTo => dateRange.end.toIso8601String().split('.')[0];

  int get intervalToSeconds {
    final number = int.parse(interval.substring(0, interval.length - 1));
    final unit = interval[interval.length - 1];
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
}
