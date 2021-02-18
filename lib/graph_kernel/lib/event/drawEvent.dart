import 'package:graph_kernel/sceneEvent.dart';

import 'sceneEvent.dart';

class DrawEvent extends SceneEvent {
  static const String id = "draw";

  @override
  String getID() => id;
}
