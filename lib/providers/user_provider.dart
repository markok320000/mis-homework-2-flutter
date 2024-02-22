import 'package:event_scheduler_project/models/user.dart';
import 'package:event_scheduler_project/resources/auth_methods.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  final AuthMethods _authMethods = AuthMethods();

  User? _user;

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
