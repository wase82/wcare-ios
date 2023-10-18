// To parse this JSON data, do
//
//     final modelPic = modelPicFromJson(jsonString);

import 'dart:convert';

class ModelPic {
  ModelPic({
    required this.respError,
    required this.respMsg,
    required this.items,
  });

  final bool respError;
  final String respMsg;
  final List<ListPic> items;

  factory ModelPic.fromRawJson(String str) => ModelPic.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelPic.fromJson(Map<String, dynamic> json) => ModelPic(
    respError: json["resp_error"],
    respMsg: json["resp_msg"],
    items:  List<ListPic>.from(json["items"].map((x) => ListPic.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "resp_error": respError,
    "resp_msg": respMsg,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class ListPic {
  ListPic({
    required this.picId,
    required this.picNama,
  });

  final String picId;
  final String picNama;

  factory ListPic.fromRawJson(String str) => ListPic.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListPic.fromJson(Map<String, dynamic> json) => ListPic(
    picId: json["pic_id"],
    picNama: json["pic_nama"],
  );

  Map<String, dynamic> toJson() => {
    "pic_id": picId,
    "pic_nama": picNama,
  };
}
