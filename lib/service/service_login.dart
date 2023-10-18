import 'package:wtoncare/model/model_login.dart';
import 'package:wtoncare/model/model_verify.dart';
import 'package:wtoncare/service/service.dart';
import 'package:http/http.dart' as http;

class ServiceAuthenticated {
  static Future<ModelVerifyUser> verifyUser(String nip) async {
    String strUrl = "${Service.mainApi}/wcare/login";

    Uri url = Uri.parse(strUrl);
    final response = await http.post(url, headers: Service.mainheader, body: {
      "username": nip,
    }).timeout(Service.durReq, onTimeout: () {
      return Future.error("timeout");
    }).onError((error, stackTrace) {
      if (error == "timeout") {
        throw APIService.timeout;
      } else {
        throw APIService.serverError;
      }
    });
    // print(response.body);
    try {
      return ModelVerifyUser.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }

  static Future<ModelLogin> reqToken(
      {required String username,
      required String token,
      required String tokenfirebase}) async {
    String strUrl = "${Service.mainApi}/wcare/verifikasitoken";
    Uri url = Uri.parse(strUrl);
    Map<String, dynamic> body = {
      'username': username,
      'token_otp': token,
      'tokenfirebase': tokenfirebase
    };
    final response = await http
        .post(url, headers: Service.mainheader, body: body)
        .timeout(Service.durReq, onTimeout: () {
      return Future.error("timeout");
    }).onError((error, stackTrace) {
      if (error == "timeout") {
        throw APIService.timeout;
      } else {
        throw APIService.serverError;
      }
    });
    try {
      return ModelLogin.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }
}
