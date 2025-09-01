import 'package:shared_preferences/shared_preferences.dart';

class PinService {
  Future<void> savePin(int pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pin', pin);
  }

  Future<int?> getPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('pin');
  }

  Future<void> deletePin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('pin');
  }

  //save isLoggedIn
  Future<void> saveIsLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<bool> getIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
