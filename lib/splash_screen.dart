// lib/screen/splash_screen.dart
import 'dart:io'; // WAJIB: Buat cek Platform
import 'package:flutter/material.dart';
import 'dart:async';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // LOGIC WAKTU BERDASARKAN OS (WINDOWS PHONE GAK DIAJAK)
    bool isIOS = false;
    try {
      isIOS = Platform.isIOS;
    } catch (e) {
      isIOS = false; // Fallback kalau web/desktop
    }

    // 1. Waktu mulai animasi (Start Delay)
    // iOS: 200ms (Sat-set)
    // Android: 1100ms (Santuy/Loading asset)
    final int startDelay = isIOS ? 200 : 1100;

    // 2. Total durasi nunggu sebelum pindah ke Login
    // iOS: 1600ms (Cukup buat animasi selesai 1200ms + buffer dikit)
    // Android: 3000ms (Lama)
    final int totalDuration = isIOS ? 1600 : 3000;

    // A. Start Animasi Logo & Teks
    Future.delayed(Duration(milliseconds: startDelay), () {
      if (mounted) _controller.forward();
    });

    // B. Pindah Halaman (Navigasi)
    Timer(Duration(milliseconds: totalDuration), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final fade = Tween(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeIn), // Sedikit lebih natural
              );
              
              final slideUp = Tween<Offset>(
                begin: const Offset(0, 0.1), // Slide dikit aja biar elegan
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutQuart, // Apple style curve (Tau darimana?... ya, tau dari Apple Developer docs lah!)
              ));

              return FadeTransition(
                opacity: fade,
                child: SlideTransition(position: slideUp, child: child),
              );
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLogo() {
    return Hero(
      tag: "logo",
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.7, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
        ),
        child: Image.asset(
          'assets/t_book_logo.png',
          width: 120,
          height: 120,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final text = 'T-Book';
    return Hero(
      tag: "title",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(text.length, (i) {
          final delay = i * 0.1;
          
          // Animasi Offset (Naik dari bawah)
          final offsetAnim = Tween<Offset>(
            begin: const Offset(0, 0.5), // Jarak dikurangin dikit biar gak terlalu jauh lompatnya
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(delay, delay + 0.4, curve: Curves.easeOutBack),
            ),
          );

          // Animasi Fade
          final fadeAnim = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(delay, delay + 0.3, curve: Curves.easeIn),
            ),
          );

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Opacity(
              opacity: fadeAnim.value,
              child: Transform.translate(
                offset: Offset(0, offsetAnim.value.dy * 30),
                child: child,
              ),
            ),
            child: Text(
              text[i],
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF4A261),
                decoration: TextDecoration.none, // Biar gak ada garis bawah kuning (BUG YANG GW BENCI DI FLUTTER)
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(),
            const SizedBox(height: 20),
            _buildTitle(),
          ],
        ),
      ),
    );
  }
}