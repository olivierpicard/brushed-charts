import 'package:graphql_flutter/graphql_flutter.dart';

enum LoadingState { rest, loading, ready }

abstract class AsyncLoadingComponent {
  // void Function(Map<String, dynamic>?, DownloadEvent)? onDownloadFinished;
  void Function(OperationException?)? onException;
  void Function()? onLoading;
}
