import 'package:flutter/material.dart';
import 'package:labelling/services/source.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntervalSelector extends StatefulWidget {
  const IntervalSelector({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IntervalSelector();
}

class _IntervalSelector extends State<IntervalSelector> {
  late final SourceService source = context.read<SourceService>();

  @override
  void initState() {
    super.initState();
    _loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        onChanged: _onInterval,
        value: source.interval,
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
    var savedInterval = prefs.getString('interval');
    savedInterval ??= SourceService.defaultInterval;
    setState(() {
      source.interval = savedInterval!;
    });
    source.update();
  }

  void _onInterval(String? interval) {
    if (interval == null) return;
    setState(() => source.interval = interval);
    source.update();
    _savePref();
  }

  Future<void> _savePref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('interval', source.interval ?? '');
  }
}
