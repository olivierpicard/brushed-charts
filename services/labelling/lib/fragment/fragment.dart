import 'package:grapher/subgraph/subgraph-kernel.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:labelling/fragment/fragment_contract.dart';
import 'package:labelling/fragment/struct.dart';
import 'package:labelling/grapherExtension/centered_text.dart';
import 'package:labelling/graphql/async_loading.dart';
import 'package:labelling/graphql/graphql.dart';
import 'package:labelling/services/fragments_model.dart';
import 'package:labelling/services/source.dart';

abstract class GraphFragment implements FragmentContract {
  final void Function() updateStateCallback;
  final SourceService source;
  final FragmentMetadata metadata;

  GraphFragment(this.metadata, this.source, this.updateStateCallback) {
    final client = Graphql.instance.client.value;
    final gqlFetcher = getGraphqlFetcher(client);
    gqlFetcher.onDownloadFinished = onReady;
    gqlFetcher.onLoading = onLoading;
    gqlFetcher.onException = onError;
    gqlFetcher.sendQuery(source);
  }

  AsyncLoadingComponent getGraphqlFetcher(GraphQLClient client);
  void onReady(Map<String, dynamic>? data, SourceService source);

  void onError(OperationException? exception) {
    const message = "An error ocurred";
    subgraph = FragmentStruct(
        visualisation: SubGraphKernel(child: CenteredText(message)));
    updateStateCallback();
  }

  void onLoading() {
    const message = "Loading... Please wait";
    subgraph = FragmentStruct(
        visualisation: SubGraphKernel(child: CenteredText(message)));
    updateStateCallback();
  }
}
