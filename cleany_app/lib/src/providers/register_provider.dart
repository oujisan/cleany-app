import 'package:flutter/material.dart';

class RegisterProvider extends ChangeNotifier {
  String _firstName = '';
  String _lastName = '';
  String _username = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isFirstNameTouched = false;
  bool _isUsernameTouched = false;
  bool _isEmailTouched = false;
  bool _isPasswordTouched = false;
  bool _isConfirmPasswordTouched = false;

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get username => _username;
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  bool get isFirstNameTouched => _isFirstNameTouched;
  bool get isUsernameTouched => _isUsernameTouched;
  bool get isEmailTouched => _isEmailTouched;
  bool get isPasswordTouched => _isPasswordTouched;
  bool get isConfirmPasswordTouched => _isConfirmPasswordTouched;

  void setFirstName(String firstName) {
    _firstName = firstName;
    notifyListeners();
  }

  void setLastName(String lastName) {
    _lastName = lastName;
    notifyListeners();
  }

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  void setFirstNameTouched() {
    _isFirstNameTouched = true;
    notifyListeners();
  }

  void setUsernameTouched() {
    _isUsernameTouched = true;
    notifyListeners();
  }

  void setEmailTouched() {
    _isEmailTouched = true;
    notifyListeners();
  }

  void setPasswordTouched() {
    _isPasswordTouched = true;
    notifyListeners();
  }

  void setConfirmPasswordTouched() {
    _isConfirmPasswordTouched = true;
    notifyListeners();
  }

  bool isUsernameExist() {
    return false;
  }

  bool isEmailExist() {
    return false;
  }

  bool get isEmailValid {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(_email);
  }

  bool get isUsernameValid {
    return RegExp(r'^[a-z0-9_]+$').hasMatch(_username);
  }

  bool get isPasswordValid {
    return RegExp(r'^(?=.*\d).{8,}$').hasMatch(_password);
  }

  bool get isPasswordMatch {
    return _password == _confirmPassword;
  }

  bool get isFormValid {
    return 
    isEmailValid && 
    isPasswordMatch && 
    isUsernameValid &&
    _firstName.trim().isNotEmpty &&
    _username.trim().isNotEmpty &&
    _email.trim().isNotEmpty &&
    _password.trim().isNotEmpty &&
    _confirmPassword.trim().isNotEmpty;
  }
}
