import 'package:flutter/material.dart';
import 'package:labelling/services/fragments_model.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class IndicatorWidget extends StatelessWidget {
  const IndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        iconSize: 30,
        icon: Icon(Icons.functions_sharp,
            color: Theme.of(context).buttonTheme.colorScheme?.primary),
        onSelected: (String selection) => onSelected(context, selection),
        itemBuilder: (context) => [
              const PopupMenuItem(child: Text('MA'), value: 'MA'),
              const PopupMenuItem(child: Text('EMA'), value: 'EMA'),
              const PopupMenuItem(child: Text('RSI'), value: 'RSI'),
              const PopupMenuItem(child: Text('MACD'), value: 'MACD'),
              const PopupMenuItem(child: Text('Volume'), value: 'Volume'),
              const PopupMenuItem(
                  child: Text('Stochastic'), value: 'Stochastic'),
            ]);
  }

  void onSelected(BuildContext context, String name) {
    final fragModel = context.read<FragmentModel>();
    fragModel.add(name);
  }
}
