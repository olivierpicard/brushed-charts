import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:labelling/graphql/price.dart';

class Graphql extends InheritedWidget {
  final PriceFetcher price;
  final ValueNotifier<GraphQLClient> client;

  Graphql({required this.client, required Widget child, Key? key})
      : price = PriceFetcher(client.value),
        super(child: GraphQLProvider(child: child, client: client), key: key);

  static Future<ValueNotifier<GraphQLClient>> init() async {
    await initHiveForFlutter();
    final HttpLink httpLink = HttpLink('http://graphql.brushed-charts.com');
    return ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(store: HiveStore()),
      ),
    );
  }

  static Graphql? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType(aspect: Graphql);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
