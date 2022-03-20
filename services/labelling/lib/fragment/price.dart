import 'package:grapher/cell/cell.dart';
import 'package:grapher/cell/event.dart';
import 'package:grapher/factory/factory.dart';
import 'package:grapher/filter/data-injector.dart';
import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/filter/json/explode.dart';
import 'package:grapher/filter/json/extract.dart';
import 'package:grapher/filter/json/to-candle2D.dart';
import 'package:grapher/geometry/candlestick.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/pack/unpack-view.dart';
import 'package:grapher/pipe/pipeIn.dart';
import 'package:grapher/subgraph/subgraph-kernel.dart';
import 'package:grapher/tag/tag.dart';
import 'package:grapher/utils/merge.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:labelling/fragment/fragment.dart';
import 'package:labelling/fragment/struct.dart';
import 'package:labelling/graphql/async_loading.dart';
import 'package:labelling/graphql/mock_price.dart';
import 'package:labelling/services/fragments_model.dart';
import 'package:labelling/services/source.dart';
import 'package:labelling/utils/map_to_stream.dart';

class PriceFragment extends GraphFragment {
  @override
  var subgraph = FragmentStruct();

  PriceFragment(FragmentMetadata metadata, SourceService source,
      void Function() updateStateCallback)
      : super(metadata, source, updateStateCallback);

  @override
  AsyncLoadingComponent getGraphqlFetcher(GraphQLClient client) =>
      MockPriceFetcher(client);

  @override
  void onReady(Map<String, dynamic>? data, SourceService source) {
    if (data == null) return;
    subgraph = FragmentStruct(
        parser: createParser(data), visualisation: createVisual());
    updateStateCallback();
  }

  GraphObject createParser(Map jsonInput) {
    return SubGraphKernel(
        child: DataInjector(
            stream: mapToStream(jsonInput),
            child: Extract(
                options: source.broker!,
                child: Explode(
                    child: ToCandle2D(
                        xLabel: "datetime",
                        yLabel: "price",
                        child: Tag(
                            name: source.broker!,
                            child: PipeIn(
                                eventType: IncomingData,
                                name: 'pipe_main')))))));
  }

  GraphObject createVisual() {
    return SubGraphKernel(
        child: UnpackFromViewEvent(
            tagName: source.broker!,
            child: DrawUnitFactory(
                template: Cell.template(
                    child: Candlestick(
                        child: MergeBranches(
                            child: PipeIn(
                                name: 'pipe_cell_event',
                                eventType: CellEvent)))))));
  }
}
