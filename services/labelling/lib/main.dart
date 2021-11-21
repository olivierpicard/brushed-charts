import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:labelling/graphql/graphql.dart';
import 'package:labelling/services/appmode.dart';
import 'package:labelling/services/source.dart';
import 'package:labelling/toolbar/toolbar.dart';
import 'package:provider/provider.dart';

import 'composer/composer.dart';

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
        body: MultiProvider(
            providers: [
          ChangeNotifierProvider(create: (context) => SourceService()),
          ChangeNotifierProvider(create: (context) => AppModeService())
        ],
            child: Column(children: [
              ToolBar(
                key: key,
              ),
              GraphComposer(),
            ])));
  }
}
