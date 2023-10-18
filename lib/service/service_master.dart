import 'package:wtoncare/model/model_kategori.dart';
import 'package:wtoncare/model/model_keparahan.dart';
import 'package:wtoncare/model/model_kriteria.dart';
import 'package:wtoncare/model/model_level.dart';
import 'package:wtoncare/model/model_lokasi.dart';
import 'package:wtoncare/model/model_pic.dart';
import 'package:wtoncare/service/service.dart';
import 'package:http/http.dart' as http;

class ServiceMaster {
  static Future<ModelLokasi> reqLokasi() async {
    String strUrl = "${Service.mainApi}/wcare/listlokasi";
    Uri url = Uri.parse(strUrl);
    final response = await http
        .post(url, headers: Service.mainheader)
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
      return ModelLokasi.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }

  static Future<ModelPic> reqPic() async {
    String strUrl = "${Service.mainApi}/wcare/listpic";
    Uri url = Uri.parse(strUrl);
    final response = await http
        .post(url, headers: Service.mainheader)
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
      return ModelPic.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }

  static Future<ModelKriteria> reqKriteria() async {
    String strUrl = "${Service.mainApi}/wcare/listkriteria";
    Uri url = Uri.parse(strUrl);
    final response = await http
        .post(url, headers: Service.mainheader)
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
      return ModelKriteria.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }

  static Future<ModelKategori> reqKategori() async {
    String strUrl = "${Service.mainApi}/wcare/listkategori";
    Uri url = Uri.parse(strUrl);
    final response = await http
        .post(url, headers: Service.mainheader)
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
      return ModelKategori.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }

  static Future<ModelKeparahan> reqKeparahan() async {
    String strUrl = "${Service.mainApi}/wcare/listkeparahan";
    Uri url = Uri.parse(strUrl);
    final response = await http
        .post(url, headers: Service.mainheader)
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
      return ModelKeparahan.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }

  static Future<ModelLevel> reqLevel() async {
    String strUrl = "${Service.mainApi}/wcare/listlevel";
    Uri url = Uri.parse(strUrl);
    final response = await http
        .post(url, headers: Service.mainheader)
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
      return ModelLevel.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }
}
