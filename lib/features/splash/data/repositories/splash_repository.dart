import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable()
class SplashRepository {
  final SharedPreferences sharedPreferences;
  SplashRepository(this.sharedPreferences);

  Future<bool> isSeen() async {
    bool _seen = (sharedPreferences.getBool('isSplashSeen') ?? false);

    if (_seen) {
      return true;
    } else {
      await sharedPreferences.setBool('isSplashSeen', true);
      return false;
    }
  }
}
