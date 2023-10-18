// To parse this JSON data, do
//
//     final modelAvatar = modelAvatarFromJson(jsonString);

import 'dart:convert';

class ModelAvatar {
  ModelAvatar({
   required this.respError,
   required this.respMsg,
   required this.avatar,
  });

  final bool respError;
  final String respMsg;
  final String? avatar;


  factory ModelAvatar.fromRawJson(String str) => ModelAvatar.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelAvatar.fromJson(Map<String, dynamic> json) => ModelAvatar(
    respError: json["resp_error"],
    respMsg: json["resp_msg"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "resp_error": respError,
    "resp_msg": respMsg,
    "avatar": avatar,
  };
}
