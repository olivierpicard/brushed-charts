import 'package:flutter/material.dart';
import 'package:grapher/filter/data-injector.dart';
import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/filter/json/explode.dart';
import 'package:grapher/filter/json/extract.dart';
import 'package:grapher/filter/json/to-candle2D.dart';
import 'package:grapher/kernel/kernel.dart';
import 'package:grapher/pipe/pipeIn.dart';
import 'package:grapher/pointer/widget.dart';
import 'package:grapher/staticLayout/stack.dart';
import 'package:grapher/tag/tag.dart';
import 'package:labelling/graphql/async_loading.dart';

import 'state_builder.dart';

class FragmentPrice extends StatefulWidget {
  final AsyncLoadingComponent loadingComponent;
  const FragmentPrice({required this.loadingComponent, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FragmentPriceState();
}

class FragmentPriceState extends FragmentBasicBuilder {
  @override
  Widget buildGraph(BuildContext context) {
    // TODO: implement buildGraph
    throw UnimplementedError();
  }
}
