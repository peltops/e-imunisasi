import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthService {
  final _sharedPreferences = SharedPreferences.getInstance();

  Future<bool> get isLogin async {
    final SharedPreferences prefs = await _sharedPreferences;
    return prefs.getBool('isLogin') ?? false;
  }

  Future<void> setLogin(bool isLogin) async {
    final SharedPreferences prefs = await _sharedPreferences;
    prefs.setBool('isLogin', isLogin);
  }

  Future<String> get passcode async {
    final SharedPreferences prefs = await _sharedPreferences;
    return prefs.getString('passcode') ?? '';
  }

  Future<void> setPasscode(String pin) async {
    final SharedPreferences prefs = await _sharedPreferences;
    prefs.setString('passcode', pin);
  }

  Future<void> deletePasscode() async {
    final SharedPreferences prefs = await _sharedPreferences;
    prefs.remove('passcode');
  }
}
