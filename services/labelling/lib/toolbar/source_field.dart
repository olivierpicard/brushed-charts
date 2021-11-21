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
  final _controller =
      TextEditingController(text: SourceService.defaultRawSource);
  late final SourceService source = context.read<SourceService>();

  @override
  void initState() {
    super.initState();
    _loadPref();
  }

  Future<void> _loadPref() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSource = prefs.getString('rawSource');
    setState(() {
      source.rawSource = savedSource ?? SourceService.defaultRawSource;
      _controller.text = source.rawSource;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width,
        child: TextField(
          onSubmitted: _onEdited,
          controller: _controller,
        ));
  }

  void _onEdited(String? rawSource) {
    rawSource ??= SourceService.defaultRawSource;
    setState(() => source.rawSource = rawSource!);
    source.update();
    _savePref();
  }

  Future<void> _savePref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('rawSource', source.rawSource);
  }
}
