import 'package:flutter/material.dart';
import 'package:labelling/services/source.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SourceField extends StatefulWidget {
  final double width;
  const SourceField({this.width = 90, Key? key}) : super(key: key);

  @override
  _SourceFieldState createState() => _SourceFieldState();
}

class _SourceFieldState extends State<SourceField> {
  final _controller = TextEditingController();
  late final SourceService source = context.read<SourceService>();

  @override
  void initState() {
    super.initState();
    _loadPref();
  }

  Future<void> _loadPref() async {
    final prefs = await SharedPreferences.getInstance();
    var savedSource = prefs.getString('rawSource');
    savedSource ??= SourceService.defaultRawSource;
    setState(() {
      source.rawSource = savedSource!;
      _controller.text = source.rawSource!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width,
        child: TextField(
          autofocus: true,
          decoration: const InputDecoration(
              isDense: true, contentPadding: EdgeInsets.fromLTRB(0, 12, 0, 10)),
          onSubmitted: _onEdited,
          controller: _controller,
        ));
  }

  void _onEdited(String rawSource) {
    setState(() => source.rawSource = rawSource);
    source.update();
    _savePref();
  }

  Future<void> _savePref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('rawSource', source.rawSource ?? '');
  }
}
