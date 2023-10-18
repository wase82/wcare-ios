// To parse this JSON data, do
//
//     final modelKategori = modelKategoriFromJson(jsonString);
import 'dart:convert';

class ModelKategori {
  ModelKategori({
    required this.respError,
    required this.respMsg,
    required this.items,
  });

  final bool respError;
  final String respMsg;
  final List<ListKategori> items;

  factory ModelKategori.fromRawJson(String str) =>
      ModelKategori.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelKategori.fromJson(Map<String, dynamic> json) => ModelKategori(
        respError: json["resp_error"],
        respMsg: json["resp_msg"],
        items: List<ListKategori>.from(
            json["items"].map((x) => ListKategori.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resp_error": respError,
        "resp_msg": respMsg,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class ListKategori {
  ListKategori({
    required this.kategoriId,
    required this.kategoriNama,
  });

  final String kategoriId;
  final String kategoriNama;

  factory ListKategori.fromRawJson(String str) =>
      ListKategori.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListKategori.fromJson(Map<String, dynamic> json) => ListKategori(
        kategoriId: json["kategori_id"],
        kategoriNama: json["kategori_nama"],
      );

  Map<String, dynamic> toJson() => {
        "kategori_id": kategoriId,
        "kategori_nama": kategoriNama,
      };
}
