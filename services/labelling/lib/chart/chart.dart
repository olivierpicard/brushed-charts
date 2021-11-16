import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:labelling/graphql/async_loading_base.dart';

class Chart extends StatefulWidget {
  final AsyncLoadingComponent loadingComponent;
  const Chart({required this.loadingComponent, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChartState();
}

abstract class LoadingStateManager extends State<Chart> {
  var _loadingState = LoadingState.rest;
  OperationException? _exception;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    widget.loadingComponent.onDownloadFinished = onFreshData;
    widget.loadingComponent.onException = onError;
    widget.loadingComponent.onLoading = onLoading;
  }

  void onFreshData(Map<String, dynamic>? data) {
    setState(() {
      _loadingState = LoadingState.ready;
      _data = data;
    });
  }

  void onError(OperationException? exception) {
    setState(() {
      _loadingState = LoadingState.error;
      _exception = exception;
    });
  }

  void onLoading() {
    setState(() {
      _loadingState = LoadingState.loading;
      _exception = null;
      _data = null;
    });
  }
}

abstract class BasicStateReaction extends LoadingStateManager {
  @override
  Widget build(BuildContext context) {
    Widget widget;
    switch (_loadingState) {
      case LoadingState.ready:
      // return buildGraph(context);
      // break;
      case LoadingState.loading:
        widget = buildLoadingWidget(context);
        break;
      case LoadingState.error:
        widget = buildExceptionWidget(context);
        break;
      case LoadingState.rest:
        widget = buildRestWidget(context);
        break;
    }

    return Expanded(child: Container(child: widget));
  }

  Widget buildGraph(BuildContext context);

  Widget buildExceptionWidget(BuildContext context) {
    return Center(
        child: Text(
            "There is an error when fetching data\n${_exception.toString()}"));
  }

  Widget buildLoadingWidget(BuildContext context) {
    return Center(
        child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColorLight)));
  }

  Widget buildRestWidget(BuildContext context) {
    return const Center(
        child: Text(
            "There is no data to display.\nEnter parameters in the header bar"));
  }
}

class ChartState extends BasicStateReaction {
  ChartState();

  @override
  Widget buildGraph(BuildContext context) {
    // TODO: implement buildGraph
    throw UnimplementedError();
  }
}
