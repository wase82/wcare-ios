import 'dart:convert';

class ModelListLaporan {
  bool respError;
  String respMsg;
  List<ListLaporan> items;

  ModelListLaporan({
    required this.respError,
    required this.respMsg,
    required this.items,
  });

  factory ModelListLaporan.fromRawJson(String str) =>
      ModelListLaporan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelListLaporan.fromJson(Map<String, dynamic> json) =>
      ModelListLaporan(
        respError: json["resp_error"],
        respMsg: json["resp_msg"],
        items: List<ListLaporan>.from(
            json["items"].map((x) => ListLaporan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resp_error": respError,
        "resp_msg": respMsg,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class ListLaporan {
  String laporanId;
  String tanggal;
  String noRegister;
  String nama;
  String kriteria;
  String keterangan;
  String statusCode;
  String status;
  String waktu;

  ListLaporan({
    required this.laporanId,
    required this.tanggal,
    required this.noRegister,
    required this.nama,
    required this.kriteria,
    required this.keterangan,
    required this.statusCode,
    required this.status,
    required this.waktu,
  });

  factory ListLaporan.fromRawJson(String str) =>
      ListLaporan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListLaporan.fromJson(Map<String, dynamic> json) => ListLaporan(
        laporanId: json["laporan_id"],
        tanggal: json["tanggal"],
        noRegister: json["no_register"],
        nama: json["nama"],
        kriteria: json["kriteria"],
        keterangan: json["keterangan"],
        statusCode: json["status_code"],
        status: json["status"],
        waktu: json["waktu"],
      );

  Map<String, dynamic> toJson() => {
        "laporan_id": laporanId,
        "tanggal": tanggal,
        "no_register": noRegister,
        "nama": nama,
        "kriteria": kriteria,
        "keterangan": keterangan,
        "status_code": statusCode,
        "status": status,
        "waktu": waktu,
      };
}
