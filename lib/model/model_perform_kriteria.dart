import 'dart:convert';

class ModelPerformKriteria {
  bool respError;
  String respMsg;
  List<DetailKriteria> detail;

  ModelPerformKriteria({
    required this.respError,
    required this.respMsg,
    required this.detail,
  });

  factory ModelPerformKriteria.fromRawJson(String str) =>
      ModelPerformKriteria.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelPerformKriteria.fromJson(Map<String, dynamic> json) =>
      ModelPerformKriteria(
        respError: json["resp_error"],
        respMsg: json["resp_msg"],
        detail: List<DetailKriteria>.from(
            json["detail"].map((x) => DetailKriteria.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resp_error": respError,
        "resp_msg": respMsg,
        "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
      };
}

class DetailKriteria {
  String kriteria;
  int total;

  DetailKriteria({
    required this.kriteria,
    required this.total,
  });

  factory DetailKriteria.fromRawJson(String str) =>
      DetailKriteria.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DetailKriteria.fromJson(Map<String, dynamic> json) => DetailKriteria(
        kriteria: json["kriteria"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "kriteria": kriteria,
        "total": total,
      };
}
