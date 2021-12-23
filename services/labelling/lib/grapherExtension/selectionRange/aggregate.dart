import 'package:grapher/cell/event.dart';
import 'package:grapher/drawUnit/drawunit.dart';
import 'package:grapher/factory/factory.dart';
import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/multi.dart';
import 'package:grapher/pack/prune-event.dart';
import 'package:grapher/pack/unpack-view.dart';
import 'package:grapher/pipe/pipeIn.dart';
import 'package:grapher/pipe/pipeOut.dart';
import 'package:grapher/tag/property.dart';
import 'package:grapher/tag/tag.dart';
import 'package:grapher/utils/merge.dart';
import 'package:labelling/fragment/struct.dart';
import 'package:labelling/grapherExtension/selectionRange/data.dart';
import 'package:labelling/grapherExtension/selectionRange/event.dart';
import 'package:labelling/grapherExtension/selectionRange/interaction.dart';
import 'package:labelling/grapherExtension/selectionRange/view.dart';

class SelectionRangeComposer {
  FragmentStruct unifiedFragment;
  SelectionRangeComposer(this.unifiedFragment);

  FragmentStruct aggregate() {
    _updateParser();
    _updateVisual();
    _updateInteraction();
    return unifiedFragment;
  }

  void _updateParser() {
    final parserSubgraph = unifiedFragment.parser;
    final children = _extractChildren(parserSubgraph);
    if (children == null) return;
    children.add(_makeParser());
  }

  void _updateVisual() {
    final visualSubgraph = unifiedFragment.visualisation;
    final children = _extractChildren(visualSubgraph);
    if (children == null) return;
    children.add(_makeVisual());
  }

  void _updateInteraction() {
    final interactionSubgraph = unifiedFragment.interaction;
    final children = _extractChildren(interactionSubgraph);
    if (children == null) {
      unifiedFragment.interaction = _makeInteraction();
      return;
    }
    children.add(_makeInteraction());
  }

  List<GraphObject>? _extractChildren(GraphObject? input) {
    if (input is! MultiPropagator) return null;
    final children = (input as MultiPropagator).children;
    return children;
  }

  GraphObject _makeParser() {
    return PipeOut(
        name: 'pipe_selection_range',
        child: SelectionRangeData(
            child: Tag(
                name: 'selection_range',
                property: TagProperty.neutralRange,
                child: PipeIn(
                    eventType: IncomingData,
                    name: 'pipe_main',
                    child: PipeIn(
                        eventType: PrunePacketEvent, name: 'pipe_main')))));
  }

  GraphObject _makeInteraction() {
    return PipeOut(
        name: 'pipe_view_event',
        child: PipeOut(
            name: 'pipe_cell_event',
            child: SelectionRangeInteraction(
                child: PipeIn(
                    eventType: SelectionRangeEvent,
                    name: 'pipe_selection_range'))));
  }

  GraphObject _makeVisual() {
    return UnpackFromViewEvent(
        tagName: 'selection_range',
        child: DrawUnitFactory(
            template: DrawUnit.template(
                child: SelectionRangeView(
                    child: MergeBranches(
                        child: PipeIn(
                            name: 'pipe_cell_event', eventType: CellEvent))))));
  }
}
