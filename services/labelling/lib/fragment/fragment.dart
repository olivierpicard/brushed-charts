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

  @override
  var subgraph = FragmentStruct();
  final FragmentMetadata metadata;
  GraphFragment(this.metadata, SourceService source, this.updateStateCallback) {
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
    print("fragment error: $exception");
    const message = "An error ocurred";
    subgraph = FragmentStruct(visualisation: CenteredText(message));
    updateStateCallback();
  }

  void onLoading() {
    print("loading");
    const message = "Loading... Please wait";
    subgraph = FragmentStruct(visualisation: CenteredText(message));
    updateStateCallback();
  }
}
