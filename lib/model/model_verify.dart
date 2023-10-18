import 'dart:convert';

class ModelVerifyUser {
  bool respError;
  String respMsg;
  String waNumber;
  String nama;

  ModelVerifyUser({
    required this.respError,
    required this.respMsg,
    required this.waNumber,
    required this.nama,
  });

  factory ModelVerifyUser.fromRawJson(String str) =>
      ModelVerifyUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelVerifyUser.fromJson(Map<String, dynamic> json) =>
      ModelVerifyUser(
        respError: json["resp_error"],
        respMsg: json["resp_msg"],
        waNumber: json["wa_number"],
        nama: json["nama"],
      );

  Map<String, dynamic> toJson() => {
        "resp_error": respError,
        "resp_msg": respMsg,
        "wa_number": waNumber,
        "nama": nama,
      };
}
