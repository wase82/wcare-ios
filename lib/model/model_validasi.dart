// To parse this JSON data, do
//
//     final modelValidasiUser = modelValidasiUserFromJson(jsonString);

import 'dart:convert';

class ModelValidasiUser {
  String token;
  List<Item> items;
  String bearerToken;
  bool success;

  ModelValidasiUser({
    required this.token,
    required this.items,
    required this.bearerToken,
    required this.success,
  });

  factory ModelValidasiUser.fromRawJson(String str) =>
      ModelValidasiUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelValidasiUser.fromJson(Map<String, dynamic> json) =>
      ModelValidasiUser(
        token: json["token"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        bearerToken: json["bearer_token"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "bearer_token": bearerToken,
        "success": success,
      };
}

class Item {
  String nip;
  String nama;
  String kdUnitKerja;
  String unitKerja;
  String kdBiroSeksi;
  String biroSeksi;
  String kdJabatan;
  String jabatan;
  String kdAgama;
  String agama;
  dynamic allowDashboard;
  dynamic allowManagement;
  dynamic allowPenjualan;

  Item({
    required this.nip,
    required this.nama,
    required this.kdUnitKerja,
    required this.unitKerja,
    required this.kdBiroSeksi,
    required this.biroSeksi,
    required this.kdJabatan,
    required this.jabatan,
    required this.kdAgama,
    required this.agama,
    this.allowDashboard,
    this.allowManagement,
    this.allowPenjualan,
  });

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        nip: json["nip"],
        nama: json["nama"],
        kdUnitKerja: json["kd_unit_kerja"],
        unitKerja: json["unit_kerja"],
        kdBiroSeksi: json["kd_biro_seksi"],
        biroSeksi: json["biro_seksi"],
        kdJabatan: json["kd_jabatan"],
        jabatan: json["jabatan"],
        kdAgama: json["kd_agama"],
        agama: json["agama"],
        allowDashboard: json["allow_dashboard"],
        allowManagement: json["allow_management"],
        allowPenjualan: json["allow_penjualan"],
      );

  Map<String, dynamic> toJson() => {
        "nip": nip,
        "nama": nama,
        "kd_unit_kerja": kdUnitKerja,
        "unit_kerja": unitKerja,
        "kd_biro_seksi": kdBiroSeksi,
        "biro_seksi": biroSeksi,
        "kd_jabatan": kdJabatan,
        "jabatan": jabatan,
        "kd_agama": kdAgama,
        "agama": agama,
        "allow_dashboard": allowDashboard,
        "allow_management": allowManagement,
        "allow_penjualan": allowPenjualan,
      };
}
