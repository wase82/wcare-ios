import 'dart:convert';

class ModelKriteria {
  bool respError;
  String respMsg;
  List<ListKriteria> items;

  ModelKriteria({
    required this.respError,
    required this.respMsg,
    required this.items,
  });

  factory ModelKriteria.fromRawJson(String str) =>
      ModelKriteria.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelKriteria.fromJson(Map<String, dynamic> json) => ModelKriteria(
        respError: json["resp_error"],
        respMsg: json["resp_msg"],
        items: List<ListKriteria>.from(
            json["items"].map((x) => ListKriteria.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resp_error": respError,
        "resp_msg": respMsg,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class ListKriteria {
  String kriteriaId;
  String kriteriaNama;
  String kriteriaKejadian;

  ListKriteria({
    required this.kriteriaId,
    required this.kriteriaNama,
    required this.kriteriaKejadian,
  });

  factory ListKriteria.fromRawJson(String str) =>
      ListKriteria.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListKriteria.fromJson(Map<String, dynamic> json) => ListKriteria(
        kriteriaId: json["kriteria_id"],
        kriteriaNama: json["kriteria_nama"],
        kriteriaKejadian: json["kriteria_kejadian"],
      );

  Map<String, dynamic> toJson() => {
        "kriteria_id": kriteriaId,
        "kriteria_nama": kriteriaNama,
        "kriteria_kejadian": kriteriaKejadian,
      };
}
