import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:labelling/graphql/async_loading.dart';
import 'package:labelling/services/source.dart';

import 'fragment.dart';

abstract class FragmentStateUpdater extends State<FragmentPrice> {
  var loadingState = LoadingState.rest;
  OperationException? exception;
  late DownloadEvent metadata;
  late Map<String, dynamic> graphSource;

  void showDialogException(BuildContext context);

  @override
  void initState() {
    super.initState();
    widget.loadingComponent.onDownloadFinished = onFreshData;
    widget.loadingComponent.onException = onError;
    widget.loadingComponent.onLoading = onLoading;
  }

  void onFreshData(Map<String, dynamic>? data, DownloadEvent metadata) {
    if (data == null) {
      goToRestState();
      return;
    }
    setState(() {
      loadingState = LoadingState.ready;
      graphSource = data;
      this.metadata = metadata;
    });
  }

  void onError(OperationException? exception) {
    setState(() {
      loadingState = LoadingState.rest;
      this.exception = exception;
    });
    showDialogException(context);
  }

  void onLoading() {
    setState(() {
      loadingState = LoadingState.loading;
      exception = null;
      graphSource = {};
    });
  }

  void goToRestState() {
    setState(() {
      loadingState = LoadingState.rest;
      graphSource = {};
      exception = null;
    });
  }
}
