import 'package:shared_preferences/shared_preferences.dart';
import '../Models/login_model.dart';

LoginModel? viewLoginDetail;
String? iAuthorization;


Future<bool> setLoginModelDetail(LoginModel? model) async {
  final prefs = await SharedPreferences.getInstance();
  String? data = model != null ? loginModelToJson(model) : null;
  bool first = await prefs.setString("user", data ?? "logout");
  return first;
}

Future<LoginModel?> getLoginModelDetail() async {
  final prefs = await SharedPreferences.getInstance();
  String? data = prefs.getString("user");
  if (data != null && data == "logout") return null;
  viewLoginDetail = data != null ? loginModelFromJson(data) : null;
  return viewLoginDetail;
}

// logout manage

Future<bool> setUserIsPro(bool isPro) async {
  final prefs = await SharedPreferences.getInstance();
  bool pro = await prefs.setBool("pro_user", isPro);
  return pro;
}






