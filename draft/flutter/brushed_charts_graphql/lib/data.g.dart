// GENERATED CODE - DO NOT MODIFY BY HAND

part of brushed_charts_graphql;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataCandle _$DataCandleFromJson(Map<String, dynamic> json) {
  return DataCandle(
    json['date'] == null ? null : DateTime.parse(json['date'] as String),
    (json['volume'] as num)?.toDouble(),
    mid: json['mid'] == null
        ? null
        : OHLC.fromJson(json['mid'] as Map<String, dynamic>),
    ask: json['ask'] == null
        ? null
        : OHLC.fromJson(json['ask'] as Map<String, dynamic>),
    bid: json['bid'] == null
        ? null
        : OHLC.fromJson(json['bid'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DataCandleToJson(DataCandle instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'volume': instance.volume,
      'mid': instance.mid,
      'bid': instance.bid,
      'ask': instance.ask,
    };

OHLC _$OHLCFromJson(Map<String, dynamic> json) {
  return OHLC(
    (json['open'] as num)?.toDouble(),
    (json['high'] as num)?.toDouble(),
    (json['low'] as num)?.toDouble(),
    (json['close'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$OHLCToJson(OHLC instance) => <String, dynamic>{
      'open': instance.open,
      'high': instance.high,
      'low': instance.low,
      'close': instance.close,
    };
