import 'package:shared_preferences/shared_preferences.dart';
import 'package:wtoncare/model/model_auth.dart';

class PrefsHelper {
  final String _dataAkun = "(Nagfj1-232}1#!";

  PrefsHelper._privateConstructor();

  static final PrefsHelper instance = PrefsHelper._privateConstructor();

  Future<SharedPreferences> _getInstance() async =>
      await SharedPreferences.getInstance();

  Future<bool> saveDataAkun(ModelAuth modelAuth) async {
    final prefs = await _getInstance();
    return await prefs.setString(_dataAkun, modelAuth.toRawJson());
  }

  Future<ModelAuth?> getDataAkun() async {
    final prefs = await _getInstance();
    String? user = prefs.getString(_dataAkun);
    if (user != null) {
      ModelAuth newUser = ModelAuth.fromRawJson(user);
      return newUser;
    }

    return null;
  }

  Future clearDataLogin() async {
    final prefs = await _getInstance();
    return prefs.remove(_dataAkun);
  }
}
