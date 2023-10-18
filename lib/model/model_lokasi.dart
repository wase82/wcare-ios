import 'dart:convert';

class ModelLokasi {
  bool respError;
  String respMsg;
  List<ListLokasi> items;

  ModelLokasi({
    required this.respError,
    required this.respMsg,
    required this.items,
  });

  factory ModelLokasi.fromRawJson(String str) =>
      ModelLokasi.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelLokasi.fromJson(Map<String, dynamic> json) => ModelLokasi(
        respError: json["resp_error"],
        respMsg: json["resp_msg"],
        items: List<ListLokasi>.from(
            json["items"].map((x) => ListLokasi.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resp_error": respError,
        "resp_msg": respMsg,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class ListLokasi {
  String lokasiId;
  String lokasiNama;

  ListLokasi({
    required this.lokasiId,
    required this.lokasiNama,
  });

  factory ListLokasi.fromRawJson(String str) =>
      ListLokasi.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListLokasi.fromJson(Map<String, dynamic> json) => ListLokasi(
        lokasiId: json["lokasi_id"],
        lokasiNama: json["lokasi_nama"],
      );

  Map<String, dynamic> toJson() => {
        "lokasi_id": lokasiId,
        "lokasi_nama": lokasiNama,
      };
}
