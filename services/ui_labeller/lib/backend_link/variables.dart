library brushed_charts_graphql;

import 'dart:convert';

abstract class GraphqlVariables {
  String toJson();
}

class VariablesGetCandles implements GraphqlVariables {
  String dateFrom;
  String dateTo;
  String instrument;
  String granularity;

  String toJson() {
    Map<String, dynamic> vars = Map();
    vars["dateFrom"] = dateFrom;
    vars["dateTo"] = dateTo;
    vars["instrument"] = instrument;
    vars["granularity"] = granularity;
    String json = JsonEncoder().convert(vars);

    return json;
  }
}
