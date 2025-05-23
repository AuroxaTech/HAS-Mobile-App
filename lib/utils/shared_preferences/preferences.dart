import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static setIntroSP(bool check) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('checkIntro', check);
  }

  static getIntroSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? boolValue = prefs.getBool("checkIntro");
    return boolValue;
  }

  static setBiometricEnabled(bool check) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('bioMetric', check);
  }

  static getBiometricEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? boolValue = prefs.getBool("bioMetric");
    return boolValue;
  }


  static setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  static getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenValue = prefs.getString("token");
    return tokenValue;
  }

  // static setRoleID(int role) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setInt('role_id', role);
  // }

  static setRoleID(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('role', role);
  }

  static getRoleID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? roleValue = prefs.getString("role");
    return roleValue;
  }

  // static getRoleID() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int? roleIdValue = prefs.getInt("role_id");
  //   return roleIdValue;
  // }

  static setUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
  }

  static getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nameValue = prefs.getString("name");
    return nameValue;
  }

  static setUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
  }

  static getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? emailValue = prefs.getString("email");
    return emailValue;
  }

  static setUserID(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('user_id', id);
  }

  static getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? idValue = prefs.getInt("user_id");
    return idValue;
  }
}
