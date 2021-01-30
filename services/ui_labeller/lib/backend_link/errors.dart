library brushed_charts_graphql;

class ResponseError implements Exception {
  String cause;
  ResponseError(int statusCode, String reasonPhrase) {
    cause = "Error $statusCode: $reasonPhrase";
  }
}
