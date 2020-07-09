import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;
  Timer _authTimer;
  final url = "http://192.168.1.22:8080/";
  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expireDate != null &&
        _expireDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(email, password, username, id, image) async {
    // open a bytestream
    var stream = http.ByteStream(Stream.castFrom(image.openRead()));
    // get file length
    var length = await image.length();
    var uri = Uri.parse(url + "sign-up");
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('imageFile', stream, length,
        filename: image.path.split("/").last);

    request.files.add(multipartFile);
    request.fields["id"] = id;
    request.fields["username"] = username;
    request.fields["email"] = email;
    request.fields["password"] = password;

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        return;
      } 
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String email, String password, String username, String id,
      File image) async {
    return _authenticate(email, password, username, id, image);
  }

  Future<void> login(String email, String password) async {
    final response = await http.post(
      url + "login",
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(
        {
          "email": email,
          "password": password,
        },
      ),
    );
    if (response.statusCode != 200) {
      return;
    }
    final responseData = jsonDecode(response.body);
    _token = responseData["token"];
    _expireDate =
        DateTime.fromMillisecondsSinceEpoch(responseData["expireDate"]);
    final userData = jsonEncode({
      "token": _token,
      "expireDate": _expireDate,
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("userData", userData);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("token")) {
      return false;
    }
    final token = prefs.getString("userData");
    if (_expireDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = token;

    notifyListeners();
    _autologout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autologout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expireDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
