import 'package:grapher/kernel/kernel.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:labelling/fragment/fragment.dart';
import 'package:labelling/fragment/struct.dart';
import 'package:labelling/graphql/async_loading.dart';
import 'package:labelling/graphql/price.dart';
import 'package:labelling/services/fragments_model.dart';
import 'package:labelling/services/source.dart';

class PriceFragment extends GraphFragment {
  PriceFragment(FragmentMetadata metadata, SourceService source)
      : super(metadata, source);

  @override
  AsyncLoadingComponent getGraphqlFetcher(GraphQLClient client) =>
      PriceFetcher(client);

  @override
  FragmentStruct onReady(Map<String, dynamic>? data, SourceService source) {
    return FragmentStruct(visualisation: GraphKernel(child: null));
  }
}
