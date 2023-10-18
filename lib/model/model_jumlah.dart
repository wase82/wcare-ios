// To parse this JSON data, do
//
//     final modelJumlah = modelJumlahFromJson(jsonString);

import 'dart:convert';

class ModelJumlah {
  ModelJumlah(
      {required this.respError,
      required this.respMsg,
      required this.jumlahlaporan,
      required this.jumlahlaporanselesai,
      required this.persen});

  final bool respError;
  final String respMsg;
  final int jumlahlaporan;
  final int jumlahlaporanselesai;
  final String persen;

  factory ModelJumlah.fromRawJson(String str) =>
      ModelJumlah.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelJumlah.fromJson(Map<String, dynamic> json) => ModelJumlah(
      respError: json["resp_error"],
      respMsg: json["resp_msg"],
      jumlahlaporan: json["jumlahlaporan"],
      jumlahlaporanselesai: json["jumlahlaporanselesai"],
      persen: json["persen"]);

  Map<String, dynamic> toJson() => {
        "resp_error": respError,
        "resp_msg": respMsg,
        "jumlahlaporan": jumlahlaporan,
        "jumlahlaporanselesai": jumlahlaporanselesai,
        "persen": persen
      };
}
