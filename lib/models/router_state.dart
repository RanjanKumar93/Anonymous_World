import 'package:anonymous_world/state/auth/auth_bloc.dart';
import 'package:flutter/material.dart';

class RouterState extends ChangeNotifier {
  String? _redir;
  AuthState authState = AuthStateUninitialized();

  String? get redir {
    final temp = _redir;
    _redir = null;
    return temp;
  }

  void changeRoute(String route) {
    _redir = route;
    notifyListeners();
  }

  void changeAuthState(AuthState state) {
    authState = state;
    notifyListeners();
  }
}
