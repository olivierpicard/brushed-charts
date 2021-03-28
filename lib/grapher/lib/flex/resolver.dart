import 'object.dart';

class FlexResolver {
  final List<FlexObject> children;
  final double zoneLength;

  FlexResolver(this.children, this.zoneLength);

  double getLength(FlexObject child) {
    final flexLen = child.length;
    if (!flexLen.isAuto) return flexLen.toPixel(zoneLength);

    return _getAutoLength(zoneLength);
  }

  double _getAutoLength(double zoneLength) {
    int counter = 0;
    double length = 0;
    for (final child in children) {
      if (child.length.isAuto) {
        counter++;
      } else {
        length += child.length.toPixel(zoneLength);
      }
    }
    final autoLength = _process(zoneLength, counter, length);
    return autoLength;
  }

  double _process(double zoneLength, int countAuto, double occupiedLength) {
    return (zoneLength - occupiedLength) / countAuto;
  }
}
