import 'package:flutter/material.dart';
import 'package:labelling/events/download.dart';
import 'package:labelling/toolbar/calendar.dart';
import 'package:labelling/toolbar/interval.dart';
import 'package:labelling/toolbar/selection.dart';

class ToolBar extends StatefulWidget {
  final void Function(DownloadEvent) downloadCallback;
  // final void Function(bool) onSelectionMode;
  const ToolBar({Key? key, required this.downloadCallback}) : super(key: key);

  @override
  _ToolBarState createState() => _ToolBarState();

  static _ToolBarState? of(BuildContext context) =>
      context.findAncestorStateOfType<_ToolBarState>();
}

class _ToolBarState extends State<ToolBar> {
  static const _defaultInterval = '30m';
  bool isSelected = false;
  DateTimeRange? dateRange;
  String interval = _defaultInterval;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(width: 30),
      const SelectionMode(),
      const SizedBox(width: 30),
      CalendarWidget(onUpdate: downloadIfReady),
      const SizedBox(width: 30),
      IntervalWidget(onUpdate: downloadIfReady),
    ]);
  }

  void update(void Function() updateRaison) => setState(updateRaison);

  void downloadIfReady() {
    emitDownloadEvent();
  }

  void emitDownloadEvent() {
    if (dateRange == null) return;
    final event = DownloadEvent(dateRange!, interval);
    widget.downloadCallback(event);
  }
}
