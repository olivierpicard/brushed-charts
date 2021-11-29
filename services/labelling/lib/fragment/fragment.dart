import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:labelling/fragment/struct.dart';
import 'package:labelling/grapherExtension/centered_text.dart';
import 'package:labelling/graphql/async_loading.dart';
import 'package:labelling/services/source.dart';

abstract class GraphFragment {
  SourceService? source;

  GraphFragment(this.source) {
    final gqlFetcher = getGraphqlFetcher();
    gqlFetcher.onDownloadFinished = onReady;
    gqlFetcher.onLoading = onLoading;
    gqlFetcher.onException = onError;
  }

  AsyncLoadingComponent getGraphqlFetcher();
  FragmentStruct onReady(Map<String, dynamic>? data, SourceService source);

  FragmentStruct onError(OperationException? exception) {
    const message = "An error ocurred";
    return FragmentStruct(visualisation: [CenteredText(message)]);
  }

  FragmentStruct onLoading() {
    const message = "Loading...\nPlease wait";
    return FragmentStruct(visualisation: [CenteredText(message)]);
  }
}
