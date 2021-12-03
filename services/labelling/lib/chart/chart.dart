import 'package:flutter/material.dart';
import 'package:labelling/composer/composer.dart';
import 'package:labelling/fragment/manager.dart';
import 'package:labelling/services/fragments_model.dart';
import 'package:provider/provider.dart';

class Chart extends StatelessWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Container();
    return ProxyProvider<FragmentModel, FragmentManager>(
      update: (_, fragmentModel, __) => FragmentManager(fragmentModel),
      child: Expanded(child: GraphComposer(key: key)),
    );
  }
}
