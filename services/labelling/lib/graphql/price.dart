import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:labelling/graphql/async_loading.dart';

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

  // void onDownloadEvent(DownloadEvent event) async {
  //   onLoading?.call();
  //   final resp = await client.query(makeQueryOption(event));
  //   callbackOnException(resp);
  //   callbackOnCorrectResponse(resp, event);
  // }

  // QueryOptions makeQueryOption(DownloadEvent event) {
  //   final query = prepareQuery(event.rawSource);
  //   return QueryOptions(document: gql(query), variables: makeVariables(event));
  // }

  // String prepareQuery(String source) {
  //   final queryWithAliasName = templateQuery.replaceAll('{{alias}}', source);
  //   return queryWithAliasName;
  // }

  // void callbackOnException(QueryResult response) {
  //   if (!response.hasException) return;
  //   onException?.call(response.exception);
  // }

  // void callbackOnCorrectResponse(QueryResult response, DownloadEvent metadata) {
  //   if (response.hasException) return;
  //   onDownloadFinished?.call(response.data, metadata);
  // }

  // Map<String, dynamic> makeVariables(DownloadEvent event) {
  //   return {
  //     "sourceSelector": {
  //       "dateFrom": event.dateFrom,
  //       "dateTo": event.dateTo,
  //       "asset": event.asset,
  //       "granularity": event.intervalToSeconds,
  //       "source": event.rawSource.toLowerCase()
  //     }
  //   };
  // }
}
