import 'package:flutter/material.dart';
import '../../widget/app_navbar.dart';
import 'child/home_screen.dart';
import 'child/explore_screen.dart';
import 'child/my_list_screen.dart';
import 'child/profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  bool _isSearchBarActive = false;

  List<Widget> get pages => [
    const HomeScreen(),
    ExploreScreen(
      onSearchBarActiveChanged: (active) {
        setState(() => _isSearchBarActive = active);
      },
    ),
    const MyListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true, 
      body: Stack(
        children: [
          pages[index],
          if (!isKeyboardOpen && !_isSearchBarActive)
            Positioned(
              left: 16,
              right: 16,
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