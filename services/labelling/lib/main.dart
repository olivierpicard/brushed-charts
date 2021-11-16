import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:labelling/chart/chart.dart';
import 'package:labelling/graphql/main.dart';
import 'package:labelling/toolbar/toolbar.dart';

Future<void> main() async {
  final gqlClient = await Graphql.init();
  runApp(Labeller(graphqlClient: gqlClient));
}

class Labeller extends StatelessWidget {
  final ValueNotifier<GraphQLClient> graphqlClient;
  const Labeller({required this.graphqlClient, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Graphql(
        client: graphqlClient,
        child: MaterialApp(
          title: 'Labeller',
          theme: ThemeData(
            colorScheme: const ColorScheme.dark(),
          ),
          home: const MainView(),
        ));
  }
}

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      ToolBar(
        key: key,
        onDownloadReady: Graphql.of(context)!.price.onDownloadEvent,
        onSelectionMode: (e) => {},
      ),
      Chart(loadingComponent: Graphql.of(context)!.price),
    ]));
  }
}
