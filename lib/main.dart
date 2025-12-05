// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screen/home/child/settings_screen.dart'; 
import 'app_settings.dart';

import 'splash_screen.dart';
import 'login_page.dart';
import 'screen/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita ambil perubahan Dark Mode dari AppSettings
    return ValueListenableBuilder<bool>(
      valueListenable: AppSettings.isDarkMode,
      builder: (context, isDark, child) {
        
        // Atur warna status bar biar keliatan tulisan jam/batre-nya
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ));

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'T_Book',
          
          // --- KONFIGURASI TEMA ---
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          
          // 1. TEMA TERANG (LIGHT)
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            primarySwatch: Colors.orange,
            scaffoldBackgroundColor: const Color(0xFFF8F9FA), // Putih agak abu dikit biar mata adem
            primaryColor: const Color(0xFFF4A261),
            
            // Default warna Card/Container
            cardColor: Colors.white,
            
            // Warna Teks Default
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Color(0xFF5D3A1A)), // Coklat tua (Default Text)
              titleLarge: TextStyle(color: Colors.black),
            ),
            
            // Warna Icon
            iconTheme: const IconThemeData(color: Color(0xFF5D3A1A)),
            
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // 2. TEMA GELAP (DARK)
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            primarySwatch: Colors.orange,
            // Warna background gelap (Dark Grey Premium), bukan hitam pekat
            scaffoldBackgroundColor: const Color(0xFF121212), 
            primaryColor: const Color(0xFFF4A261),
            
            // Card jadi abu gelap
            cardColor: const Color(0xFF1E1E1E),
            
            // Teks jadi putih/abu terang
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Color(0xFFE0E0E0)),
              titleLarge: TextStyle(color: Colors.white),
            ),
            
            iconTheme: const IconThemeData(color: Colors.white70),
            
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E1E1E),
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginPage(),
            '/home': (context) => const HomePage(), 
          },
        );
      },
    );
  }
}