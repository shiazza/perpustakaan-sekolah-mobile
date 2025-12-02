// lib/widget/app_navbar.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppNavBar extends StatelessWidget {
  final int index;
  final Function(int) onTap;

  const AppNavBar({
    super.key,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 61,
      child: BottomNavigationBar(
        currentIndex: index,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        iconSize: 28,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house_fill),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.compass_fill),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book_fill),
            label: 'My List',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_crop_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
