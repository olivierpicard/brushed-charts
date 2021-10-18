import 'dart:math';

import 'dart:ui';

class Misc {
  static Color randomColor([maxColor = 0xFFFFFFFF]) {
    final rgb = Random().nextInt(maxColor);
    var color = Color(rgb);
    color = color.withAlpha(255);

    return color;
  }
}
