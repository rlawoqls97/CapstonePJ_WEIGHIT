import 'package:flutter/foundation.dart';

class JoinToggle extends ChangeNotifier {
  bool _isSignUp = false;

  bool get isSignUp => _isSignUp;

  void toggle() {
    _isSignUp = !_isSignUp;
    notifyListeners();
  }
}
