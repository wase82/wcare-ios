// To parse this JSON data, do
//
//     final modelPerform = modelPerformFromJson(jsonString);

import 'dart:convert';

class ModelPerform {
  ModelPerform({
    required this.respError,
    required this.respMsg,
    required this.detail,
  });

  final bool respError;
  final String respMsg;
  final List<Detail> detail;


  factory ModelPerform.fromRawJson(String str) => ModelPerform.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelPerform.fromJson(Map<String, dynamic> json) => ModelPerform(
    respError: json["resp_error"],
    respMsg: json["resp_msg"],
    detail:  List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "resp_error": respError,
    "resp_msg": respMsg,
    "detail":  List<dynamic>.from(detail.map((x) => x.toJson())),
  };
}

class Detail {
  Detail({
    required this.prosentase,
    required this.total,
  });

  final String prosentase;
  final int total;



  factory Detail.fromRawJson(String str) => Detail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    prosentase: json["prosentase"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "prosentase": prosentase,
    "total": total,
  };
}
