import 'package:event_scheduler_project/models/user.dart';
import 'package:event_scheduler_project/pages/account_page.dart';
import 'package:event_scheduler_project/pages/add_event_page.dart';
import 'package:event_scheduler_project/pages/login_page.dart';
import 'package:event_scheduler_project/pages/map_page.dart';
import 'package:event_scheduler_project/pages/messages_page.dart';
import 'package:event_scheduler_project/pages/my_events_page.dart';
import 'package:event_scheduler_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../components/bottom_navigation_item.dart';
import '../styles/app_colors.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

enum Menus {
  login,
  home,
  favorite,
  add,
  map,
  // user,
  messages
}

final pages = [
  LoginPage(),
  HomePage(),
  MyEventsPage(),
  AddEventPage(),
  MapPage(),
  // AccountPage(),
  MessagesPage(),
  // Center(
  //   child: Text('Favorite'),
  // ),
  // Center(
  //   child: Text('Add Post'),
  // ),
  // ChatPage(),
  // ProfilePage()
];

class _MainPageState extends State<MainPage> {
  Menus currentIndex = Menus.home;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[currentIndex.index],
      bottomNavigationBar: MyBottomNavigation(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
    );
  }
}

class MyBottomNavigation extends StatelessWidget {
  final Menus currentIndex;
  final ValueChanged<Menus> onTap;
  const MyBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 87,
      margin: const EdgeInsets.all(24),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            top: 17,
            child: Container(
              height: 70,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Row(
                children: [
                  Expanded(
                    child: BottomNavigationItem(
                        onPressed: () => onTap(Menus.home),
                        index: Menus.home.index,
                        icon: Icons.home,
                        current: currentIndex,
                        name: Menus.home),
                  ),
                  Expanded(
                    child: BottomNavigationItem(
                        onPressed: () => onTap(Menus.favorite),
                        index: Menus.favorite.index,
                        icon: Icons.favorite,
                        current: currentIndex,
                        name: Menus.favorite),
                  ),
                  Spacer(),
                  Expanded(
                    child: BottomNavigationItem(
                        onPressed: () => onTap(Menus.map),
                        index: Menus.map.index,
                        icon: Icons.map,
                        current: currentIndex,
                        name: Menus.map),
                  ),
                  Expanded(
                    child: BottomNavigationItem(
                        onPressed: () => onTap(Menus.messages),
                        index: Menus.messages.index,
                        icon: Icons.account_circle,
                        current: currentIndex,
                        name: Menus.messages),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () => onTap(Menus.add),
              child: Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, size: 30),
              ),
            ),
          )
        ],
      ),
    );
  }
}
