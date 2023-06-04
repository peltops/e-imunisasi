import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable()
class SplashRepository {
  final SharedPreferences _sharedPreferences;
  SplashRepository({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  Future<bool> isSeen() async {
    bool _seen = (_sharedPreferences.getBool('isSplashSeen') ?? false);

    if (_seen) {
      return true;
    } else {
      await _sharedPreferences.setBool('isSplashSeen', true);
      return false;
    }
  }
}
