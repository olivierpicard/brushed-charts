import 'package:flutter/material.dart';

class DownloadEvent {
  final String interval;
  final DateTimeRange dateRange;
  final String asset;
  final String source;
  DownloadEvent(this.dateRange, this.interval, this.asset, this.source);

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
