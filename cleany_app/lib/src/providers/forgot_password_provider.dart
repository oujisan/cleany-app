import 'package:flutter/material.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  String _email = '';
  String _verifcode = '';
  String _newPasswd = '';
  String _confirmNewPasswd = '';
  bool _isEmailTouched = false;
  bool _isVerifcodeTouched = false;
  bool _isNewPasswdTouched = false;
  bool _isConfirmNewPasswdTouched = false;
  bool _isNewPasswdVisible = false;
  bool _isConfirmNewPasswdVisible = false;

  String get email => _email;
  String get verifcode => _verifcode;
  String get newPasswd => _newPasswd;
  String get confirmNewPasswd => _confirmNewPasswd;
  bool get isEmailTouched => _isEmailTouched;
  bool get isVerifcodeTouched => _isVerifcodeTouched;
  bool get isNewPasswdTouched => _isNewPasswdTouched;
  bool get isConfirmNewPasswdTouched => _isConfirmNewPasswdTouched;
  bool get isNewPasswdVisible => _isNewPasswdVisible;
  bool get isConfirmNewPasswdVisible => _isConfirmNewPasswdVisible;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setVerifcode(String verifcode) {
    _verifcode = verifcode;
    notifyListeners();
  }

  void setNewPasswd(String newPasswd) {
    _newPasswd = newPasswd;
    notifyListeners();
  }

  void setConfirmNewPasswd(String confirmNewPasswd) {
    _confirmNewPasswd = confirmNewPasswd;
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

  void setNewPasswdTouched() {
    _isNewPasswdTouched = true;
    notifyListeners();
  }

  void setConfirmNewPasswdTouched() {
    _isConfirmNewPasswdTouched = true;
    notifyListeners();
  }

  void toggleNewPasswdVisibility() {
    _isNewPasswdVisible = !_isNewPasswdVisible;
    notifyListeners();
  }

  void toggleConfirmNewPasswdVisibility() {
    _isConfirmNewPasswdVisible = !_isConfirmNewPasswdVisible;
    notifyListeners();
  }

  bool get isPasswordMatch {
    return _newPasswd == _confirmNewPasswd;
  }

  bool get isEmailValid {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_email);
  }

  bool get isPasswordValid {
    return RegExp(r'^(?=.*\d).{8,}$').hasMatch(_newPasswd);
  }

  bool get isVerificationCodeValid {
    return RegExp(r'^\d{6}$').hasMatch(_verifcode) && _verifcode.trim().isNotEmpty;
  }
}
