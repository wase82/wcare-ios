import 'dart:convert';

class ModelDetailLaporan {
  bool respError;
  String respMsg;
  String laporanId;
  String tanggal;
  String noRegister;
  String namaPetugas;
  String unit;
  String kriteria;
  String lokasi;
  String pic;
  String kategori;
  String keparahan;
  String deskripsi;
  String latitude;
  String longitude;
  String step;
  String jumlah;
  String foto;
  String statusCode;
  String status;
  String tanggalKonfirm;
  String tanggalTindakLanjut;
  String keteranganTindak;
  String fotoTindak;

  ModelDetailLaporan({
    required this.respError,
    required this.respMsg,
    required this.laporanId,
    required this.tanggal,
    required this.noRegister,
    required this.namaPetugas,
    required this.unit,
    required this.kriteria,
    required this.lokasi,
    required this.pic,
    required this.kategori,
    required this.keparahan,
    required this.deskripsi,
    required this.latitude,
    required this.longitude,
    required this.step,
    required this.jumlah,
    required this.foto,
    required this.statusCode,
    required this.status,
    required this.tanggalKonfirm,
    required this.tanggalTindakLanjut,
    required this.keteranganTindak,
    required this.fotoTindak,
  });

  factory ModelDetailLaporan.fromRawJson(String str) =>
      ModelDetailLaporan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelDetailLaporan.fromJson(Map<String, dynamic> json) =>
      ModelDetailLaporan(
        respError: json["resp_error"],
        respMsg: json["resp_msg"],
        laporanId: json["laporan_id"],
        tanggal: json["tanggal"],
        noRegister: json["no_register"],
        namaPetugas: json["nama_petugas"],
        unit: json["unit"],
        kriteria: json["kriteria"],
        lokasi: json["lokasi"],
        pic: json["pic"],
        kategori: json["kategori"],
        keparahan: json["keparahan"],
        deskripsi: json["deskripsi"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        step: json["step"],
        jumlah: json["jumlah"],
        foto: json["foto"],
        statusCode: json["status_code"],
        status: json["status"],
        tanggalKonfirm: json["tanggal_konfirm"],
        tanggalTindakLanjut: json["tanggal_tindak_lanjut"],
        keteranganTindak: json["keterangan_tindak"],
        fotoTindak: json["foto_tindak"],
      );

  Map<String, dynamic> toJson() => {
        "resp_error": respError,
        "resp_msg": respMsg,
        "laporan_id": laporanId,
        "tanggal": tanggal,
        "no_register": noRegister,
        "nama_petugas": namaPetugas,
        "unit": unit,
        "kriteria": kriteria,
        "lokasi": lokasi,
        "pic": pic,
        "kategori": kategori,
        "keparahan": keparahan,
        "deskripsi": deskripsi,
        "latitude": latitude,
        "longitude": longitude,
        "step": step,
        "jumlah": jumlah,
        "foto": foto,
        "status_code": statusCode,
        "status": status,
        "tanggal_konfirm": tanggalKonfirm,
        "tanggal_tindak_lanjut": tanggalTindakLanjut,
        "keterangan_tindak": keteranganTindak,
        "foto_tindak": fotoTindak,
      };
}
