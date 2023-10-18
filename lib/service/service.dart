class Service {
  static String mainApi = "https://wika-beton.co.id/";
  static String keyApi = "WTONCARE";

  static Map<String, String> mainheader = {
    'Accept': '*/*',
    'token': keyApi,
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static Map<String, String> headerUser(String username) {
    return {
      "token": keyApi,
      "username": username,
    };
  }

  static Map<String, String> headerSimpanLaporan(
      String username, String step, String kdPat) {
    return {
      "token": keyApi,
      "username": username,
      'step': step,
      "kdpat": kdPat,
    };
  }

  static Map<String, String> headerListLaporan(
      String username, String level, String kdPat, String step, String picId) {
    return {
      "token": keyApi,
      "username": username,
      "level": level,
      "kdpat": kdPat,
      "step": step,
      "picid": picId
    };
  }

  static Map<String, String> headerGrafik(
      String username, String picId, String kdPat) {
    return {
      "token": keyApi,
      "username": username,
      "picid": picId,
      "kdpat": kdPat,
    };
  }

  static const Duration durReq = Duration(seconds: 80);
}

enum APIService { timeout, serverError, decodeError }
