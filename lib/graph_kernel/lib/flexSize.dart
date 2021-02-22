import 'dart:ui';

class FlexSize {
  Size percent = Size.zero;
  Size pixel = Size.zero;

  FlexSize({this.pixel, this.percent});

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
