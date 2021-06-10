import 'dart:async';
import 'dart:convert';
import '../models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';

class Auth with ChangeNotifier {
  String _userId;
  String _token;
  DateTime _tokenExpiry;
  Timer _authTimer;
  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_tokenExpiry != null &&
        _tokenExpiry.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print('no userdata');
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryData = DateTime.parse(extractedData['_tokenExpiry']);
    if (expiryData.isBefore(DateTime.now())) {
      print('expired token');
      return false;
    }
    _token = extractedData['_token'];
    _tokenExpiry = expiryData;
    _userId = extractedData['userId'];
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> _authenticate(String email, String password, String key) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$key?key=AIzaSyAHfYUJDvm1tZ689mpNKOXYwM5JhmGNI5I';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _tokenExpiry = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        '_token': _token,
        '_tokenExpiry': _tokenExpiry.toIso8601String(),
        'userId': userId
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _tokenExpiry = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _tokenExpiry.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
