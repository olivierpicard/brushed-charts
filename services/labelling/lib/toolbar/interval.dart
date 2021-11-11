import 'package:flutter/material.dart';
import 'package:labelling/toolbar/download_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntervalSelector extends StatefulWidget {
  final void Function() onUpdate;
  final DownloadInfo data;

  const IntervalSelector({required this.data, required this.onUpdate, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _IntervalSelector();
}

class _IntervalSelector extends State<IntervalSelector> {
  @override
  void initState() {
    super.initState();
    _loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        onChanged: _onInterval,
        value: widget.data.interval,
        items: <String>[
          '1s',
          '2s',
          '5s',
          '1m',
          '2m',
          '5m',
          '10m',
          '15m',
          '30m',
          '45m',
          '1h',
          '2h',
          '4h',
          '1d',
          '1w',
          '1M',
          '1y'
        ]
            .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
            .toList());
  }

  Future<void> _loadPref() async {
    final prefs = await SharedPreferences.getInstance();
    final savedInterval = prefs.getString('interval');
    setState(() {
      widget.data.interval = savedInterval ?? DownloadInfo.defaultInterval;
    });
  }

  void _onInterval(String? interval) async {
    if (interval == null) return;
    setState(() => widget.data.interval = interval);
    await _savePref();
    widget.onUpdate();
  }

  Future<void> _savePref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('interval', widget.data.interval);
  }
}
