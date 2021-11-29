import 'package:flutter/material.dart';

class FunctionWidget extends StatelessWidget {
  const FunctionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return PopupMenuButton(
        iconSize: 30,
        icon: Icon(Icons.functions_sharp,
            color: Theme.of(context).buttonTheme.colorScheme?.primary),
        onSelected: onSelected,
        itemBuilder: (context) => [
              const PopupMenuItem(child: Text('MA'), value: 'MA.inplace'),
              const PopupMenuItem(child: Text('EMA'), value: 'EMA.inplace'),
              const PopupMenuItem(child: Text('RSI'), value: 'RSI.separated'),
              const PopupMenuItem(child: Text('MACD'), value: 'MACD.separated'),
              const PopupMenuItem(
                  child: Text('Stochastic'), value: 'Stochastic.separated'),
            ]);
  }

  void onSelected(String? value) {
    value
  }
}
