import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:labelling/graphql/async_loading.dart';
import 'package:labelling/mock/json_oanda.dart';
import 'package:labelling/services/source.dart';

class MockPriceFetcher with AsyncLoadingComponent {
  final GraphQLClient client;
  final oandaJSON = getMockOandaJSON();
  MockPriceFetcher(this.client);

  @override
  void sendQuery(SourceService source) async {
    Future.delayed(const Duration(seconds: 5), () {
      onLoading?.call();
      onDownloadFinished?.call(oandaJSON, source);
    });
  }
}
