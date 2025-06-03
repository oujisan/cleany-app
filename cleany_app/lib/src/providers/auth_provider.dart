import 'package:cleany_app/src/models/register_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cleany_app/src/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  String _email = '';
  String _verifcode = '';
  String _firstName = '';
  String _lastName = '';
  String _username = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isCooldown = false;
  bool _isEmailTouched = false;
  bool _isVerifcodeTouched = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isFirstNameTouched = false;
  bool _isUsernameTouched = false;
  bool _isConfirmPasswordTouched = false;
  bool _isPasswordTouched = false;
  bool _isLoading = false;
  bool _loginButton = true;
  bool _registerButton = true;
  bool _sendCodeButton = true;
  bool _verifyCodeButton = true;
  bool _resetPasswordButton = true;
  int _duration = 60;
  Timer? _timer;
  final AuthService _authService = AuthService();

  String get email => _email;
  String get verifcode => _verifcode;
  String get durationInString => _duration.toString();
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get username => _username;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  String get error => _authService.getError;
  String get message => _authService.getMessage;
  bool get isEmailTouched => _isEmailTouched;
  bool get isVerifcodeTouched => _isVerifcodeTouched;
  bool get isCooldown => _isCooldown;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  bool get isFirstNameTouched => _isFirstNameTouched;
  bool get isUsernameTouched => _isUsernameTouched;
  bool get isPasswordTouched => _isPasswordTouched;
  bool get isConfirmPasswordTouched => _isConfirmPasswordTouched;
  bool get isLoading => _isLoading;
  bool get loginButton => _loginButton;
  bool get registerButton => _registerButton;
  bool get sendCodeButton => _sendCodeButton;
  bool get verifyCodeButton => _verifyCodeButton;
  bool get resetPasswordButton => _resetPasswordButton;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setVerifcode(String verifcode) {
    _verifcode = verifcode;
    notifyListeners();
  }

  void setEmailTouched() {
    _isEmailTouched = true;
    notifyListeners();
  }

  void setVerifcodeTouched() {
    _isVerifcodeTouched = true;
    notifyListeners();
  }

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

  void setCooldown() {
    _isCooldown = true;
    notifyListeners();
  }

  void toggleLoginButton(){
    _loginButton = !_loginButton;
    notifyListeners();
  }

  void toggleRegisterButton(){
    _registerButton = !_registerButton;
    notifyListeners();
  }

  void toggleSendCodeButton(){
    _sendCodeButton = !_sendCodeButton;
    notifyListeners();
  }

  void toggleVerifyCodeButton(){
    _verifyCodeButton = !_verifyCodeButton;
    notifyListeners();
  }

  void toggleResetPasswordButton(){
    _resetPasswordButton = !_resetPasswordButton;
    notifyListeners();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration > 0) {
        _duration--;
        notifyListeners();
      } else {
        _duration = 60;
        _isCooldown = false;
        _timer?.cancel();
        notifyListeners();
      }
    });
  }

  bool get isPasswordMatch {
    return _password == _confirmPassword;
  }

  bool get isEmailValid {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_email);
  }

  bool get isPasswordValid {
    return RegExp(r'^(?=.*\d).{8,}$').hasMatch(_password);
  }

  bool get isVerificationCodeValid {
    return RegExp(r'^\d{6}$').hasMatch(_verifcode) &&
        _verifcode.trim().isNotEmpty;
  }

  bool get isUsernameValid {
    return RegExp(r'^[a-z0-9_]+$').hasMatch(_username);
  }

  bool get isRegistrationFormValid {
    return isEmailValid &&
        isPasswordMatch &&
        isUsernameValid &&
        _firstName.trim().isNotEmpty &&
        _username.trim().isNotEmpty &&
        _email.trim().isNotEmpty &&
        _password.trim().isNotEmpty &&
        _confirmPassword.trim().isNotEmpty;
  }

  Future<bool> login() async {
    _isLoading = true;
    notifyListeners();

    final isSuccess = await _authService.login(_email, _password);

    _isLoading = false;
    notifyListeners();

    return isSuccess;
  }

  Future<bool> register() async {
    _isLoading = true;
    notifyListeners();

    RegisterModel registerData = RegisterModel(
      firstName: _firstName,
      lastName: _lastName,
      username: _username,
      email: _email,
      password: _password,
    );

    final isSuccess = await _authService.register(registerData);

    _isLoading = false;
    notifyListeners();

    return isSuccess;
  }

  Future<bool> forgotPassword() async {
    _isLoading = true;
    notifyListeners();

    final isSuccess = await _authService.forgotPassword(_email);

    _isLoading = false;
    notifyListeners();

    return isSuccess;
  }

  Future<bool> verifyCode() async {
    _isLoading = true;
    notifyListeners();

    final isSuccess = await _authService.verifyCode(_email, _verifcode);

    _isLoading = false;
    notifyListeners();

    return isSuccess;
  }

  Future<bool> resetPassword() async {
    _isLoading = true;
    notifyListeners();

    final isSuccess = await _authService.resetPassword(_email, _password);

    _isLoading = false;
    notifyListeners();

    return isSuccess;
  }
}
