library brushed_charts_graphql;

import 'package:http/http.dart' as http;
import 'data.dart';
import 'utils.dart';
import 'variables.dart';
import 'query_definition.dart';

Future<List<DataCandle>> getCandles(VariablesGetCandles variables) async {
  final request = _makeRequest(variables);
  final response = await _sendRequest(request);
  final candles = _extractCandles(response);

  return candles;
}

http.Request _makeRequest(VariablesGetCandles variables) {
  var request = prepareRequest();
  final inlineQuery = query_get_candles.replaceAll(RegExp(r'\n'), '\\n');
  final jsonQuery = buildQueryBody(inlineQuery, variables: variables);
  request = fillRequestBody(request, jsonQuery);

  return request;
}

Future<http.Response> _sendRequest(http.Request request) async {
  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  return response;
}

List<DataCandle> _extractCandles(http.Response response) {
  List<DataCandle> candles = [];
  final jsonResponse = responseToJson(response);
  final listCandles = jsonResponse['getCandles'] as List<dynamic>;
  for (final jsonCandle in listCandles) {
    final candle = DataCandle.fromJson(jsonCandle);
    candles.add(candle);
  }

  return candles;
}
