// To parse this JSON data, do
//
//     final modelKeparahan = modelKeparahanFromJson(jsonString);

import 'dart:convert';

class ModelKeparahan {
  bool respError;
  String respMsg;
  List<ListKeparahan> items;

  ModelKeparahan({
    required this.respError,
    required this.respMsg,
    required this.items,
  });

  factory ModelKeparahan.fromRawJson(String str) =>
      ModelKeparahan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelKeparahan.fromJson(Map<String, dynamic> json) => ModelKeparahan(
        respError: json["resp_error"],
        respMsg: json["resp_msg"],
        items: List<ListKeparahan>.from(
            json["items"].map((x) => ListKeparahan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resp_error": respError,
        "resp_msg": respMsg,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class ListKeparahan {
  String keparahanId;
  String keparahanLevel;
  String keparahanNama;

  ListKeparahan({
    required this.keparahanId,
    required this.keparahanLevel,
    required this.keparahanNama,
  });

  factory ListKeparahan.fromRawJson(String str) =>
      ListKeparahan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListKeparahan.fromJson(Map<String, dynamic> json) => ListKeparahan(
        keparahanId: json["keparahan_id"],
        keparahanLevel: json["keparahan_level"],
        keparahanNama: json["keparahan_nama"],
      );

  Map<String, dynamic> toJson() => {
        "keparahan_id": keparahanId,
        "keparahan_level": keparahanLevel,
        "keparahan_nama": keparahanNama,
      };
}
