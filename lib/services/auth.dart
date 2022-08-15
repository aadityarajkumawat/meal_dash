import 'package:flutter/material.dart';

class AuthState {
  var authenticated = false;
  var accessToken = '';
}

class Auth with ChangeNotifier {
  final AuthState _authState = AuthState();

  AuthState get authState => _authState;

  void setAuthenticated(AuthState authState) {
    _authState.accessToken = authState.accessToken;
    _authState.authenticated = authState.authenticated;
    notifyListeners();
  }
}
