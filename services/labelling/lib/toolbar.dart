import 'package:flutter/material.dart';
import 'package:labelling/events/download.dart';
import 'package:labelling/toolbar/calendar.dart';
import 'package:labelling/toolbar/download_info.dart';
import 'package:labelling/toolbar/interval.dart';
import 'package:labelling/toolbar/selection.dart';

class ToolBar extends StatefulWidget {
  final void Function(DownloadEvent) onDownloadReady;
  final void Function(bool) onSelectionMode;
  const ToolBar(
      {Key? key, required this.onDownloadReady, required this.onSelectionMode})
      : super(key: key);

  @override
  _ToolBarState createState() => _ToolBarState();

  static _ToolBarState? of(BuildContext context) =>
      context.findAncestorStateOfType<_ToolBarState>();
}

class _ToolBarState extends State<ToolBar> {
  final downloadInfo = DownloadInfo();
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(width: 30),
      SelectionMode(onSelect: widget.onSelectionMode),
      const SizedBox(width: 30),
      CalendarWidget(data: downloadInfo, onUpdate: emitDownloadEvent),
      const SizedBox(width: 30),
      IntervalSelector(data: downloadInfo, onUpdate: emitDownloadEvent),
    ]);
  }

  void emitDownloadEvent() {
    if (downloadInfo.dateRange == null) return;
    final event = DownloadEvent(downloadInfo.dateRange!, downloadInfo.interval);
    widget.onDownloadReady(event);
  }
}
