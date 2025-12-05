// lib/widget/app_navbar.dart
import 'dart:ui'; 
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
    // Cek Mode Gelap/Terang
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // WARNA KONFIGURASI
    const activeColor = Color(0xFFF4A261); // Orange (Literally))
    
    // Icon mati: Abu terang di Dark Mode, Abu gelap di Light Mode
    final inactiveColor = isDark ? Colors.white54 : Colors.grey.shade400;

    // Background Glass: Hitam transparan (Dark) vs Putih transparan (Light)
    final glassColor = isDark 
        ? const Color(0xFF1E1E1E).withOpacity(0.85) 
        : Colors.white.withOpacity(0.85);

    // Border tipis di atas: Putih tipis (Dark) vs Abu tipis (Light)
    final borderColor = isDark 
        ? Colors.white.withOpacity(0.1) 
        : Colors.grey.withOpacity(0.2);

    return ClipRect(
      child: BackdropFilter(
        // Blur agak dikuatin dikit biar teks di belakangnya gak bikin pusing
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), 
        child: Container(
          decoration: BoxDecoration(
            color: glassColor, 
            border: Border(
              top: BorderSide(
                color: borderColor,
                width: 0.5,
              ),
            ),
          ),
          // BUNGKUS PAKE THEME BUAT MATIIN RIPPLE EFFECT (BERAT DIKIT TAPI BIKIN UI LEBIH SMOOOTH SE-SMOOTH PAHA SAPI)
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              currentIndex: index,
              onTap: onTap,
              backgroundColor: Colors.transparent, // Transparan biar container di atas yg ngatur warna
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              
              selectedItemColor: activeColor,
              unselectedItemColor: inactiveColor,
              
              selectedFontSize: 12,
              unselectedFontSize: 12,
              iconSize: 26,
              
              items: const [
                BottomNavigationBarItem(
                  activeIcon: Icon(CupertinoIcons.house_fill),
                  icon: Icon(CupertinoIcons.house),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(CupertinoIcons.compass_fill),
                  icon: Icon(CupertinoIcons.compass),
                  label: 'Jelajah',
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(CupertinoIcons.book_fill),
                  icon: Icon(CupertinoIcons.book),
                  label: 'Pinjaman',
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(CupertinoIcons.person_crop_circle_fill),
                  icon: Icon(CupertinoIcons.person_crop_circle),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}