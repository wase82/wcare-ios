import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wtoncare/model/model_avatar.dart';
import 'package:wtoncare/model/model_general.dart';
import 'package:wtoncare/service/service.dart';
import 'package:http/http.dart' as http;

class ServiceUser {
  static Future<ModelGeneral> updateProfil(
      String username, String nama, String email, String telp) async {
    String strUrl = "${Service.mainApi}/wcare/updateprofil";
    Uri url = Uri.parse(strUrl);

    final response = await http.post(url,
        headers: Service.headerUser(username),
        body: {
          "nama": nama,
          "email": email,
          "telp": telp
        }).timeout(Service.durReq, onTimeout: () {
      return Future.error("timeout");
    }).onError((error, stackTrace) {
      if (error == "timeout") {
        throw APIService.timeout;
      } else {
        throw APIService.serverError;
      }
    });
    try {
      return ModelGeneral.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }

  static Future<ModelAvatar> updatePhoto(
      String username, XFile filePhoto) async {
    String strUrl = "${Service.mainApi}/wcare/updateavatar";
    Uri url = Uri.parse(strUrl);

    var request = http.MultipartRequest("POST", url)
      ..headers.addAll(Service.headerUser(username));
    request.files.add(http.MultipartFile.fromBytes(
        'foto', await File.fromUri(Uri.parse(filePhoto.path)).readAsBytes(),
        filename:
            "$username.${DateFormat('ddMMYYHHmmss').format(DateTime.now())}.jpg",
        contentType: MediaType('image', 'jpg')));
    final streamedResponse =
        await request.send().timeout(Service.durReq, onTimeout: () {
      return Future.error("timeout");
    }).onError((error, stackTrace) {
      if (error == "timeout") {
        throw APIService.timeout;
      } else {
        throw APIService.serverError;
      }
    });
    var response = await http.Response.fromStream(streamedResponse);

    try {
      return ModelAvatar.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }
}
