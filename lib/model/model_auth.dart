import 'dart:convert';

class ModelAuth {
  ModelAuth({
    this.username = "",
    this.nama = "",
    this.telp = "",
    this.email = "",
    this.picId = "",
    this.bagian = "",
    this.step = "",
    this.avatar = "",
    this.level = "",
    this.device = "",
    this.kdPat = "",
    this.unitNama = "",
    this.dateTimeLogin,
  });

  final String username;
  final String nama;
  final String telp;
  final String email;
  final String picId;
  final String bagian;
  final String step;
  final String avatar;
  final String level;
  final String device;
  final String kdPat;
  final String unitNama;
  final DateTime? dateTimeLogin;

  factory ModelAuth.fromRawJson(String str) =>
      ModelAuth.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelAuth.fromJson(Map<String, dynamic> json) => ModelAuth(
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
        dateTimeLogin:
            DateTime.tryParse(json["dateTimeLogin"]) ?? DateTime(2000),
      );

  Map<String, dynamic> toJson() => {
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
        "dateTimeLogin": dateTimeLogin?.toIso8601String() ?? DateTime(2000),
      };
  ModelAuth copyWith({
    String? username,
    String? nama,
    String? telp,
    String? email,
    String? picId,
    String? bagian,
    String? step,
    String? avatar,
    String? level,
    String? device,
    String? kdPat,
    String? unitNama,
    DateTime? dateTimeLogin,
  }) =>
      ModelAuth(
        username: username ?? this.username,
        nama: nama ?? this.nama,
        telp: telp ?? this.telp,
        email: email ?? this.email,
        picId: picId ?? this.picId,
        bagian: bagian ?? this.bagian,
        step: step ?? this.step,
        avatar: avatar ?? this.avatar,
        level: level ?? this.level,
        device: device ?? this.device,
        kdPat: kdPat ?? this.kdPat,
        unitNama: unitNama ?? this.unitNama,
        dateTimeLogin: dateTimeLogin ?? this.dateTimeLogin,
      );
}
