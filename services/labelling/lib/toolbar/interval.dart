import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntervalWidget extends StatefulWidget {
  final void Function() onUpdate;
  const IntervalWidget({required this.onUpdate, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IntervalWidget();
}

class _IntervalWidget extends State<IntervalWidget> {
  static const String _defaultInterval = '30m';
  String interval = _defaultInterval;

  @override
  void initState() {
    super.initState();
    _loadPref();
  }

  void _loadPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      interval = prefs.getString('interval') ?? _defaultInterval;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        onChanged: _onInterval,
        value: interval,
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

  void _onInterval(String? interval) {
    if (interval == null) return;
    setState(() async {
      this.interval = interval;
      await _savePref();
    });
    widget.onUpdate();
  }

  Future<void> _savePref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('interval', interval);
  }
}
