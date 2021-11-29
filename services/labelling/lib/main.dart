import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:labelling/graphql/graphql.dart';
import 'package:labelling/services/appmode.dart';
import 'package:labelling/services/fragments.dart';
// import 'package:labelling/services/fragments.dart';
import 'package:labelling/services/source.dart';
import 'package:labelling/toolbar/toolbar.dart';
import 'package:provider/provider.dart';

// import 'composer/composer.dart';

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
          ChangeNotifierProvider(create: (_) => SourceService()),
          ChangeNotifierProvider(create: (_) => AppModeService()),
          ChangeNotifierProxyProvider<SourceService, FragmentModel>(
              create: (context) => FragmentModel(context.read<SourceService>()),
              update: (_, source, __) =>
                  FragmentModel(source)
        ],
            child: Column(children: [
              ToolBar(key: key), /*GraphComposer(key: key)*/
            ])));
  }
}
