import 'package:flutter/material.dart';

class DownloadEvent {
  final String interval;
  final DateTimeRange dateRange;
  DownloadEvent(this.dateRange, this.interval);
}
