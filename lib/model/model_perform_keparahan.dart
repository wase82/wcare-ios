// To parse this JSON data, do
//
//     final modelPerformKeparahan = modelPerformKeparahanFromJson(jsonString);

import 'dart:convert';

class ModelPerformKeparahan {
  bool respError;
  String respMsg;
  List<DetailKeparahan> detail;

  ModelPerformKeparahan({
    required this.respError,
    required this.respMsg,
    required this.detail,
  });

  factory ModelPerformKeparahan.fromRawJson(String str) =>
      ModelPerformKeparahan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelPerformKeparahan.fromJson(Map<String, dynamic> json) =>
      ModelPerformKeparahan(
        respError: json["resp_error"],
        respMsg: json["resp_msg"],
        detail: List<DetailKeparahan>.from(
            json["detail"].map((x) => DetailKeparahan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resp_error": respError,
        "resp_msg": respMsg,
        "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
      };
}

class DetailKeparahan {
  String level;
  String nama;
  String warna;
  int total;

  DetailKeparahan({
    required this.level,
    required this.nama,
    required this.warna,
    required this.total,
  });

  factory DetailKeparahan.fromRawJson(String str) =>
      DetailKeparahan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DetailKeparahan.fromJson(Map<String, dynamic> json) =>
      DetailKeparahan(
        level: json["level"],
        nama: json["nama"],
        warna: json["warna"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "level": level,
        "nama": nama,
        "warna": warna,
        "total": total,
      };
}
