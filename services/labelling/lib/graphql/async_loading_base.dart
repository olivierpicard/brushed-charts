import 'package:graphql_flutter/graphql_flutter.dart';

enum LoadingState { rest, loading, ready, error }

abstract class AsyncLoadingComponent {
  void Function(Map<String, dynamic>?)? onDownloadFinished;
  void Function(OperationException?)? onException;
  void Function()? onLoading;
}
