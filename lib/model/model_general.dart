// To parse this JSON data, do
//
//     final modelGeneral = modelGeneralFromJson(jsonString);

import 'dart:convert';

class ModelGeneral {
  ModelGeneral({
    required this.respError,
    required this.respMsg,
  });

  final bool respError;
  final String respMsg;

  factory ModelGeneral.fromRawJson(String str) => ModelGeneral.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelGeneral.fromJson(Map<String, dynamic> json) => ModelGeneral(
    respError: json["resp_error"],
    respMsg: json["resp_msg"],
  );

  Map<String, dynamic> toJson() => {
    "resp_error": respError,
    "resp_msg": respMsg,
  };
}
