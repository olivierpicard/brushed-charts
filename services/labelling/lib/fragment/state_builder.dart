import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:labelling/graphql/async_loading.dart';
import 'package:labelling/utils/dialog.dart';
import 'state_updater.dart';

abstract class FragmentBasicBuilder extends FragmentStateUpdater {
  @override
  Widget build(BuildContext context) {
    Widget widget;
    switch (loadingState) {
      case LoadingState.ready:
        widget = buildGraph(context);
        break;
      case LoadingState.loading:
        widget = buildLoadingWidget(context);
        break;
      case LoadingState.rest:
        widget = buildRestWidget(context);
        break;
    }

    return Expanded(child: Container(child: widget));
  }

  Widget buildGraph(BuildContext context);

  @override
  void showDialogException(BuildContext context) {
    Timer(const Duration(milliseconds: 100), () {
      DialogBasic(
          context: context,
          title: 'Graphql fetching error',
          body: 'There is an error when fetching data\n\n$exception');
    });
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
            "There is no data to display.\nEnter parameters in the header bar",
            textAlign: TextAlign.center));
  }
}
