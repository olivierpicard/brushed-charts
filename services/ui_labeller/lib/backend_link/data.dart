library brushed_charts_graphql;

import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class DataCandle {
  final DateTime date;
  final double volume;
  final OHLC mid;
  final OHLC bid;
  final OHLC ask;

  DataCandle(this.date, this.volume, {this.mid, this.ask, this.bid});

  factory DataCandle.fromJson(Map<String, dynamic> json) =>
      _$DataCandleFromJson(json);

  Map<String, dynamic> toJson() => _$DataCandleToJson(this);
}

@JsonSerializable()
class OHLC {
  final double open;
  final double high;
  final double low;
  final double close;

  OHLC(this.open, this.high, this.low, this.close);

  factory OHLC.fromJson(Map<String, dynamic> json) => _$OHLCFromJson(json);
  Map<String, dynamic> toJson() => _$OHLCToJson(this);
}
