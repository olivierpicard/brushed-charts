import 'dart:ui';

class FlexSize {
  var percent;
  var pixel;

  FlexSize({this.pixel = Size.zero, this.percent = Size.zero});

  Size geSize(Size canvasSize) {
    final width = _percentToPixelWidth(canvasSize) + pixel.width;
    final height = _percentToPixelHeight(canvasSize) + pixel.height;

    return Size(width, height);
  }

  double _percentToPixelWidth(Size canvasSize) =>
      (percent.width * canvasSize.width) / 100;

  double _percentToPixelHeight(Size canvasSize) =>
      (percent.height * canvasSize.height) / 100;
}
