class OHLC {
  final double open, high, low, close;

  OHLC(Map<String, double> map)
      : open = map['open']!,
        high = map['high']!,
        low = map['low']!,
        close = map['close']!;
}
