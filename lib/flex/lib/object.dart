import 'length.dart';
import 'package:kernel/drawable.dart';
import 'package:kernel/kernel.dart';

abstract class FlexObject extends Drawable {
  var flexLength = FlexLength("auto");

  FlexObject(GraphKernel kernel) : super(kernel);
}
