import 'package:brushed_charts_graphql/main.dart' as graphql;
import 'package:flutter/material.dart';
import 'package:labeling_helper/scene.dart';

main(List<String> args) async {
  runApp(App());
  /* final variables = graphql.VariablesGetCandles();
  variables.dateFrom = "2021-01-20 10:00:00";
  variables.dateTo = "2021-01-20 10:10:00";
  variables.instrument = "EUR_USD";
  variables.granularity = "S5";
  List<graphql.DataCandle> candles;

  try {
    candles = await graphql.getCandles(variables);
  } on graphql.ResponseError catch (e) {
    print(e.cause);
  } */
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(brightness: Brightness.dark, primaryColor: Colors.blueGrey),
      home: Scaffold(
          body: CustomPaint(
        painter: Scene(),
        child: Container(),
      )),
    );
  }
}
