import 'package:event_scheduler_project/models/user.dart';
import 'package:event_scheduler_project/resources/auth_methods.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  late User _user; // User instance
  bool _isLogged = false;

  User get user => _user; // Getter for the user instance
  bool get isLogged => _isLogged; // Getter for the isLogged boolean

  void setUser(User user) {
    _user = user;
    _isLogged = true;
    notifyListeners(); // Notify listeners about the change
  }
}
