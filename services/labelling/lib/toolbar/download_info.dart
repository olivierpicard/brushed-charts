import 'package:flutter/material.dart';

class DownloadInfo {
  static const defaultAsset = 'OANDA:EUR_USD';
  static const defaultInterval = '30m';
  static final defaultTimeRange = DateTimeRange(
      start: DateTime.now().toUtc().subtract(const Duration(days: 3)),
      end: DateTime.now().toUtc());

  DateTimeRange dateRange = defaultTimeRange;
  String interval = defaultInterval;
  String asset = defaultAsset;
}
