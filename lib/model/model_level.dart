// To parse this JSON data, do
//
//     final modelLevel = modelLevelFromJson(jsonString);

import 'dart:convert';

class ModelLevel {
  ModelLevel({
    required this.respError,
    required this.respMsg,
    required this.items,
  });

  final bool respError;
  final String respMsg;
  final List<ListLevel> items;


  factory ModelLevel.fromRawJson(String str) => ModelLevel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelLevel.fromJson(Map<String, dynamic> json) => ModelLevel(
    respError: json["resp_error"],
    respMsg: json["resp_msg"],
    items:  List<ListLevel>.from(json["items"].map((x) => ListLevel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "resp_error": respError,
    "resp_msg": respMsg,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class ListLevel {
  ListLevel({
    required this.val,
    required this.label,
  });

  final String val;
  final String label;



  factory ListLevel.fromRawJson(String str) => ListLevel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListLevel.fromJson(Map<String, dynamic> json) => ListLevel(
    val: json["val"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "val": val,
    "label": label,
  };
}
