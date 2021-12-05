import 'package:grapher/kernel/kernel.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:labelling/fragment/fragment.dart';
import 'package:labelling/fragment/struct.dart';
import 'package:labelling/grapherExtension/centered_text.dart';
import 'package:labelling/graphql/async_loading.dart';
import 'package:labelling/graphql/price.dart';
import 'package:labelling/services/fragments_model.dart';
import 'package:labelling/services/source.dart';

class PriceFragment extends GraphFragment {
  PriceFragment(FragmentMetadata metadata, SourceService source,
      void Function() updateStateCallback)
      : super(metadata, source, updateStateCallback);

  @override
  AsyncLoadingComponent getGraphqlFetcher(GraphQLClient client) =>
      PriceFetcher(client);

  @override
  void onReady(Map<String, dynamic>? data, SourceService source) {
    print("ready");
    subgraph = FragmentStruct(visualisation: CenteredText('Data is at home'));
    updateStateCallback();
  }
}
