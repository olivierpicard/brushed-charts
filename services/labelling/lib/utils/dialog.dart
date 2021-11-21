import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogBasic {
  final BuildContext context;
  final String title;
  final String body;

  DialogBasic(
      {required this.context, required this.body, required this.title}) {
    _showMaterialDialog();
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(body),
            actions: <Widget>[
              TextButton(
                  onPressed: () => _dismissDialog(), child: const Text('Ok'))
            ],
          );
        });
  }
}
