import 'package:flutter/material.dart';
import 'package:labelling/toolbar/download_info.dart';

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
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width,
        child: TextField(
          onSubmitted: _onEdited,
          controller: _controller,
        ));
  }

  void _onEdited(String? asset) {
    if (asset == null) return;
    setState(() {
      widget.data.asset = asset;
    });
    widget.onUpdate();
  }
}
