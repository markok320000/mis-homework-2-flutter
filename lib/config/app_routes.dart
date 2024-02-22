import '../pages/main_page.dart';

class AppRoutes {
  static final pages = {
    // login: (context) => LoginPage(),
    // home: (context) => HomePage(),
    main: (context) => MainPage(),
    // editProfile: (context) => EditProfilePage(),
    // nearby: (context) => NearbyPage(),
    // user: (context) => UserPage(),
  };

  static const login = '/';
  static const home = '/home';
  static const main = '/main';
  static const editProfile = '/edit_profile';
  static const nearby = '/nearby';
  static const user = '/user';
}
