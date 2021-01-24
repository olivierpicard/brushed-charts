library brushed_charts_graphql;

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'variables.dart';
import 'errors.dart';

http.Request prepareRequest() {
  var headers = {'Content-Type': 'application/json'};
  var request =
      http.Request('POST', Uri.parse('http://localhost:3330/graphql'));
  request.headers.addAll(headers);

  return request;
}

String buildQueryBody(String query, {GraphqlVariables variables}) {
  final jsonVariables = variables.toJson();
  final jsonQuery = '{"query":"$query","variables":$jsonVariables}';

  return jsonQuery;
}

http.Request fillRequestBody(http.Request request, String jsonQuery) {
  request.body = jsonQuery;
  return request;
}

Map<String, dynamic> responseToJson(http.Response response) {
  if (response.statusCode != 200) {
    throw ResponseError(response.statusCode, response.reasonPhrase);
  }

  final jsonBody = JsonDecoder().convert(response.body);
  final cleanedResponse = jsonBody['data'] as Map<String, dynamic>;

  return cleanedResponse;
}
