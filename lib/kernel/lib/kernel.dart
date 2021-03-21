import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/custom_paint.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter/widgets.dart';
import 'package:kernel/linkEvent.dart';
import 'propagator/single.dart';
import 'drawZone.dart';
import 'misc/Init.dart';
import 'drawEvent.dart';
import 'object.dart';

class GraphKernel extends ChangeNotifier
    with SinglePropagator, GraphObject
    implements CustomPainter {
  GraphObject? _objectToRepaint;

  GraphKernel({GraphObject? child}) {
    Init.child(this, child);
    propagate(KernelLinkEvent(this));
  }

  @override
  void paint(Canvas canvas, Size size) {
    print("paint");
    final drawZone = new DrawZone(Offset.zero, size);
    final drawEvent = new DrawEvent(this, canvas, drawZone);
    propagate(drawEvent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    print("sdsds");
    if (_objectToRepaint == null) return false;

    return true;
  }

  setState(GraphObject object) {
    print("setState");
    _objectToRepaint = object;
    notifyListeners();
  }

  @override
  bool? hitTest(Offset position) => null;
  @override
  void addListener(listener) => null;
  @override
  void removeListener(listener) => null;
  @override
  get semanticsBuilder => null;
  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;

  @override
  SingleChildRenderObjectElement createElement() {
    // TODO: implement createElement
    throw UnimplementedError();
  }

  @override
  RenderCustomPaint createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    throw UnimplementedError();
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    // TODO: implement debugDescribeChildren
    throw UnimplementedError();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    // TODO: implement debugFillProperties
  }

  @override
  void didUnmountRenderObject(covariant RenderCustomPaint renderObject) {
    // TODO: implement didUnmountRenderObject
  }

  @override
  // TODO: implement foregroundPainter
  CustomPainter? get foregroundPainter => throw UnimplementedError();

  @override
  // TODO: implement isComplex
  bool get isComplex => throw UnimplementedError();

  @override
  // TODO: implement key
  Key? get key => throw UnimplementedError();

  @override
  // TODO: implement painter
  CustomPainter? get painter => throw UnimplementedError();

  @override
  // TODO: implement size
  Size get size => throw UnimplementedError();

  @override
  DiagnosticsNode toDiagnosticsNode(
      {String? name, DiagnosticsTreeStyle? style}) {
    // TODO: implement toDiagnosticsNode
    throw UnimplementedError();
  }

  @override
  String toStringDeep(
      {String prefixLineOne = '',
      String? prefixOtherLines,
      DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    // TODO: implement toStringDeep
    throw UnimplementedError();
  }

  @override
  String toStringShallow(
      {String joiner = ', ',
      DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    // TODO: implement toStringShallow
    throw UnimplementedError();
  }

  @override
  String toStringShort() {
    // TODO: implement toStringShort
    throw UnimplementedError();
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderCustomPaint renderObject) {
    // TODO: implement updateRenderObject
  }

  @override
  // TODO: implement willChange
  bool get willChange => throw UnimplementedError();
}
