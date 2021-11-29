import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:labelling/graphql/async_loading.dart';
import 'package:labelling/services/source.dart';

class PriceFetcher with AsyncLoadingComponent {
  final GraphQLClient client;
  PriceFetcher(this.client);

  final String templateQuery = """
  query(\$sourceSelector: SourceSelector!) {
    {{alias}}: ohlc_price(sourceSelector:\$sourceSelector){
      datetime
      timestamp
      uniform_volume
      price {
          open
          high
          low
          close
      }
    }
}
""";

  void onDownloadEvent(SourceService source) async {
    onLoading?.call();
    final sourceCopy = SourceService.copy(source);
    final resp = await client.query(makeQueryOption(sourceCopy));
    callbackOnException(resp);
    callbackOnCorrectResponse(resp, source);
  }

  QueryOptions makeQueryOption(SourceService source) {
    final query = prepareQuery(source.broker);
    return QueryOptions(document: gql(query), variables: makeVariables(source));
  }

  String prepareQuery(String broker) {
    final queryWithAliasName = templateQuery.replaceAll('{{alias}}', broker);
    return queryWithAliasName;
  }

  void callbackOnException(QueryResult response) {
    if (!response.hasException) return;
    onException?.call(response.exception);
  }

  void callbackOnCorrectResponse(QueryResult response, SourceService metadata) {
    if (response.hasException) return;
    onDownloadFinished?.call(response.data, metadata);
  }

  Map<String, dynamic> makeVariables(SourceService source) {
    return {
      "sourceSelector": {
        "dateFrom": source.dateFrom,
        "dateTo": source.dateTo,
        "asset": source.asset,
        "granularity": source.intervalToSeconds,
        "source": source.rawSource.toLowerCase()
      }
    };
  }
}
