import 'main.dart';
import 'unit.dart';

class FlexLength {
  static const AUTO = "auto";
  late final double value;
  late final Unit unit;

  FlexLength(String definition) {
    _tryInitPixel(definition);
    _tryInitPercent(definition);
    _tryInitAuto(definition);
    _signalWrongInit(definition);
  }

  void _tryInitPixel(String definition) {
    if (definition.endsWith('px')) {
      final upperBound = definition.length - 2;
      final extractedValue = definition.substring(0, upperBound);
      value = double.parse(extractedValue);
      unit = Unit.PX;
    }
  }

  void _tryInitPercent(String definition) {
    if (definition.endsWith('%')) {
      final upperBound = definition.length - 1;
      final extractedValue = definition.substring(0, upperBound);
      value = double.parse(extractedValue);
      unit = Unit.PERCENT;
    }
  }

  void _tryInitAuto(String definition) {
    if (definition == FlexLength.AUTO) {
      unit = Unit.AUTO;
      value = double.nan;
    }
  }

  void _signalWrongInit(String definition) {
    // ignore: unnecessary_null_comparison
    if (value == null || unit == null) {
      throw FormatException("Can't parse the given FlexLength: $definition");
    }
  }

  double toPixel(double zoneLength) {
    if (unit == Unit.AUTO)
      return double.nan;
    else if (unit == Unit.PX) return value;
    final percent = value * zoneLength / 100;

    return percent;
  }

  bool get isAuto => (unit == Unit.AUTO);
}
