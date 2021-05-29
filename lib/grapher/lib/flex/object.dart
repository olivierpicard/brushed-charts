import 'length.dart';
import '/kernel/drawable.dart';

abstract class FlexObject extends Drawable {
  final FlexLength length;
  FlexObject({String length = "auto"}) : this.length = FlexLength(length);
}
