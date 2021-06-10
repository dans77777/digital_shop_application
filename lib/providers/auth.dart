import 'dart:convert';
import '../models/http_exception.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/widgets.dart';

class Auth with ChangeNotifier {
  String _userId;
  String _token;
  DateTime _tokenExpiry;

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
      notifyListeners();
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

  void logout() {
    _token = null;
    _tokenExpiry = null;
    _userId = null;
    notifyListeners();
  }
}
