import 'package:flutter/material.dart';
import 'package:labelling/toolbar/download_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssetSelector extends StatefulWidget {
  final DownloadInfo data;
  final double width;
  final void Function() onUpdate;
  const AssetSelector(
      {required this.data, required this.onUpdate, this.width = 90, Key? key})
      : super(key: key);

  @override
  _AssetSelectorState createState() => _AssetSelectorState();
}

class _AssetSelectorState extends State<AssetSelector> {
  final _controller = TextEditingController(text: DownloadInfo.defaultAsset);

  @override
  void initState() {
    super.initState();
    _loadPref();
  }

  Future<void> _loadPref() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAsset = prefs.getString('asset');
    setState(() {
      widget.data.asset = savedAsset ?? DownloadInfo.defaultAsset;
      _controller.text = widget.data.asset;
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

  void _onEdited(String? asset) {
    setState(() => widget.data.asset = asset ?? DownloadInfo.defaultAsset);
    _savePref();
    widget.onUpdate();
  }

  Future<void> _savePref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('asset', widget.data.asset);
  }
}
