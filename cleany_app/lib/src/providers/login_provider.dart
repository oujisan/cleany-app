import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _isPasswordVisible = false;
  bool _isEmailTouched = false;
  bool _isPasswordTouched = false;

  String get email => _email;
  String get password => _password;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isEmailTouched => _isEmailTouched;
  bool get isPasswordTouched => _isPasswordTouched;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void setEmailTouched(){
    _isEmailTouched = true;
    notifyListeners();
  }

  void setPasswordTouched(){
    _isPasswordTouched = true;
    notifyListeners();
  }

  bool get isEmailValid {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(_email);
  }
}