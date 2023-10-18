// To parse this JSON data, do
//
//     final modelLogin = modelLoginFromJson(jsonString);

import 'dart:convert';

class ModelLogin {
  ModelLogin({
    required this.respError,
    required this.respMsg,
    required this.username,
    required this.nama,
    required this.telp,
    required this.email,
    required this.picId,
    required this.bagian,
    required this.step,
    required this.avatar,
    required this.level,
    required this.device,
    required this.kdPat,
    required this.unitNama,
  });

  final bool respError;
  final String respMsg;
  final String? username;
  final String? nama;
  final String? telp;
  final String? email;
  final String? picId;
  final String? bagian;
  final String? step;
  final String? avatar;
  final String? level;
  final String? device;
  final String? kdPat;
  final String? unitNama;

  factory ModelLogin.fromRawJson(String str) =>
      ModelLogin.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelLogin.fromJson(Map<String, dynamic> json) => ModelLogin(
        respError: json["resp_error"],
        respMsg: json["resp_msg"],
        username: json["username"],
        nama: json["nama"],
        telp: json["telp"],
        email: json["email"],
        picId: json["pic_id"],
        bagian: json["bagian"],
        step: json["step"],
        avatar: json["avatar"],
        level: json["level"],
        device: json["device"],
        kdPat: json["kd_pat"],
        unitNama: json["unit_nama"],
      );

  Map<String, dynamic> toJson() => {
        "resp_error": respError,
        "resp_msg": respMsg,
        "username": username,
        "nama": nama,
        "telp": telp,
        "email": email,
        "pic_id": picId,
        "bagian": bagian,
        "step": step,
        "avatar": avatar,
        "level": level,
        "device": device,
        "kd_pat": kdPat,
        "unit_nama": unitNama,
      };
}
