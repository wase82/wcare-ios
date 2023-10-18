import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wtoncare/model/model_auth.dart';
import 'package:wtoncare/model/model_detail_laporan.dart';
import 'package:wtoncare/model/model_general.dart';
import 'package:wtoncare/model/model_keparahan.dart';
import 'package:wtoncare/model/model_kriteria.dart';
import 'package:wtoncare/model/model_lokasi.dart';
import 'package:wtoncare/model/model_jumlah.dart';
import 'package:wtoncare/model/model_kategori.dart';
import 'package:wtoncare/model/model_list_laporan.dart';
import 'package:wtoncare/model/model_perfom.dart';
import 'package:wtoncare/model/model_perform_keparahan.dart';
import 'package:wtoncare/model/model_perform_kriteria.dart';
import 'package:wtoncare/model/model_pic.dart';
import 'package:wtoncare/service/service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ServiceLaporan {
  static Future<ModelListLaporan> getListLaporan(
    String username,
    String level,
    String kdPad,
    String step,
    String picId,
    String dari,
    String sampai,
    String status,
  ) async {
    String strUrl = "${Service.mainApi}/wcare/listlaporan";
    Uri url = Uri.parse(strUrl);
    final response = await http.post(url,
        headers: Service.headerListLaporan(username, level, kdPad, step, picId),
        body: {
          "dari": dari,
          "sampai": sampai,
          "status": status,
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
      return ModelListLaporan.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }

  static Future<ModelListLaporan> getLaporanku(String username) async {
    String strUrl = "${Service.mainApi}/wcare/listlaporanku";
    Uri url = Uri.parse(strUrl);
    final response = await http
        .post(url, headers: Service.headerUser(username))
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
      return ModelListLaporan.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }

  static Future<ModelGeneral> simpanLaporan({
    required String username,
    required String step,
    required String kdPat,
    required String tanggal,
    required ListLokasi lokasi,
    required ListPic pic,
    required ListKriteria kriteria,
    required ListKategori kategori,
    required ListKeparahan keparahan,
    required String keterangan,
    required String kejadian,
    required double latitude,
    required double longitude,
    required XFile file,
    required int jumlah,
  }) async {
    String strUrl = "${Service.mainApi}/wcare/simpanlaporan";
    Uri url = Uri.parse(strUrl);

    var request = http.MultipartRequest("POST", url)
      ..headers.addAll(Service.headerSimpanLaporan(username, step, kdPat));
    request.fields['tanggal'] = tanggal;
    request.fields['lokasi'] = lokasi.lokasiId;
    request.fields['pic'] = pic.picId;
    request.fields['kriteria'] = kriteria.kriteriaId;
    request.fields['kategori'] = kategori.kategoriId;
    request.fields['keparahan'] = keparahan.keparahanId;
    request.fields['keterangan'] = keterangan;
    request.fields['kejadian'] = kejadian;
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();
    request.fields['jumlah'] = jumlah.toString();
    request.files.add(http.MultipartFile.fromBytes(
        'foto', await File.fromUri(Uri.parse(file.path)).readAsBytes(),
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
    // print(response.body);

    try {
      return ModelGeneral.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }

  static Future<ModelDetailLaporan> detailLaporan(
      {required String username, required String idLaporan}) async {
    String strUrl = "${Service.mainApi}/wcare/detaillaporan";
    Uri url = Uri.parse(strUrl);

    final response = await http.post(url,
        headers: Service.headerUser(username),
        body: {"laporan_id": idLaporan}).timeout(Service.durReq, onTimeout: () {
      return Future.error("timeout");
    }).onError((error, stackTrace) {
      if (error == "timeout") {
        throw APIService.timeout;
      } else {
        throw APIService.serverError;
      }
    });
    try {
      return ModelDetailLaporan.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }

  static Future<ModelGeneral> simpanFollowUp(
      {required String username,
      required String laporanId,
      required String keterangan,
      required XFile file,
      required ModelAuth modelAuth}) async {
    String strUrl = "${Service.mainApi}/wcare/simpantindaklanjut";
    Uri url = Uri.parse(strUrl);

    var request = http.MultipartRequest("POST", url)
      ..headers.addAll(Service.headerUser(username));
    request.fields['laporan_id'] = laporanId;
    request.fields['keterangan'] = keterangan;
    request.files.add(http.MultipartFile.fromBytes(
        'foto', await File.fromUri(Uri.parse(file.path)).readAsBytes(),
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
      return ModelGeneral.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }

  static Future<ModelPerform> detailPerforma({
    required String username,
    required String picId,
    required String kdPat,
  }) async {
    String strUrl = "${Service.mainApi}/wcare/grafiklaporan";
    Uri url = Uri.parse(strUrl);

    final response = await http
        .post(url, headers: Service.headerGrafik(username, picId, kdPat))
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
      return ModelPerform.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }

  static Future<ModelPerformKriteria> performaKriteria({
    required String username,
    required String picId,
    required String kdPat,
  }) async {
    String strUrl = "${Service.mainApi}/wcare/grafikkriteria";
    Uri url = Uri.parse(strUrl);

    final response = await http
        .post(url, headers: Service.headerGrafik(username, picId, kdPat))
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
      return ModelPerformKriteria.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }

  static Future<ModelPerformKeparahan> performaKeparahan({
    required String username,
    required String picId,
    required String kdPat,
  }) async {
    String strUrl = "${Service.mainApi}/wcare/grafikkeparahan";
    Uri url = Uri.parse(strUrl);

    final response = await http
        .post(url, headers: Service.headerGrafik(username, picId, kdPat))
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
      return ModelPerformKeparahan.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }

  static Future<ModelJumlah> detailProsentase(
      {required String username,
      required String kdPat,
      required String picId}) async {
    String strUrl = "${Service.mainApi}/wcare/jumlahlaporan";
    Uri url = Uri.parse(strUrl);

    final response = await http
        .post(url, headers: Service.headerGrafik(username, picId, kdPat))
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
      return ModelJumlah.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }

  static Future<ModelGeneral> forwarLaporan(
      {required String username, required String laporanId}) async {
    String strUrl = "${Service.mainApi}/wcare/forwardlaporan";
    Uri url = Uri.parse(strUrl);

    Map<String, String> body = {"laporan_id": laporanId};

    final response = await http
        .post(url, headers: Service.headerUser(username), body: body)
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
      return ModelGeneral.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }

  static Future<ModelGeneral> updateProses(
      {required String username, required String laporanId}) async {
    String strUrl = "${Service.mainApi}/wcare/updateproses";
    Uri url = Uri.parse(strUrl);

    Map<String, String> body = {"laporan_id": laporanId};

    final response = await http
        .post(url, headers: Service.headerUser(username), body: body)
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
      return ModelGeneral.fromRawJson(response.body);
    } catch (e) {
      throw APIService.decodeError;
    }
  }
}
