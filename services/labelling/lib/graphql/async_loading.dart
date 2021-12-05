import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:labelling/services/source.dart';

enum LoadingState { rest, loading, ready }

abstract class AsyncLoadingComponent {
  void Function(Map<String, dynamic>?, SourceService)? onDownloadFinished;
  void Function(OperationException?)? onException;
  void Function()? onLoading;
  void sendQuery(SourceService source);
}
