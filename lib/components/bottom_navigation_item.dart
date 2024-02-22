import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../pages/main_page.dart';

class BottomNavigationItem extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Menus current;
  final Menus name;
  final int index;

  const BottomNavigationItem(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.index,
      required this.current,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: index == current.index ? Colors.black : Colors.grey,
      ),
      iconSize: 31.0,
    );
  }
}
