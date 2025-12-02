// lib/screen/home/home.dart
import 'package:flutter/material.dart';
import '../../widget/app_navbar.dart';
import 'child/home_screen.dart';
import 'child/profile_screen.dart';
import 'child/settings_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  final pages = [
    HomeScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[index],
          // navbar melayang di bawah
          Positioned(
            left: 16,
            right: 16,
            // posisikan di paling bawah lalu biarkan SafeArea menambahkan padding bottom sekali
            bottom: 0,
            child: SafeArea(
              top: false,
              bottom: true,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(26),
                color: Colors.white.withOpacity(0.9),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: AppNavBar(
                    index: index,
                    onTap: (i) => setState(() => index = i),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
