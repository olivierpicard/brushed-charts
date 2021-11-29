import 'package:flutter/material.dart';
import 'package:grapher/kernel/kernel.dart';
import 'package:grapher/kernel/object.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:labelling/fragment/fragment.dart';
import 'package:labelling/fragment/struct.dart';
import 'package:labelling/graphql/async_loading.dart';
import 'package:labelling/graphql/price.dart';
import 'package:labelling/services/source.dart';

class PriceFragment extends GraphFragment {
  final subgraphs = FragmentStruct();

  PriceFragment();

  @override
  AsyncLoadingComponent initLoadingComponent(GraphQLClient client) =>
      PriceFetcher(client);

  @override
  GraphObject buildGraph(context) {
    return GraphKernel(child: null);
  }
}
