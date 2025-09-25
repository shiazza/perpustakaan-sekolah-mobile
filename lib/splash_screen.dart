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
  late Animation<double> _animation;
  bool _showSecondScreen = false;

  @override
  void initState() {
    super.initState();
    
    // Animasi untuk logo dan teks
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    
    _controller.forward();
    
    // Setelah delay, tampilkan layar kedua (oranye)
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _showSecondScreen = true;
      });
      
      // Navigasi ke halaman login setelah animasi selesai
      Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 800),
      firstChild: _buildFirstScreen(),
      secondChild: _buildSecondScreen(),
      crossFadeState: _showSecondScreen 
          ? CrossFadeState.showSecond 
          : CrossFadeState.showFirst,
    );
  }

  Widget _buildFirstScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/t_book_logo.png',
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _animation,
              child: const Text(
                'T-Book',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF4A261),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF4A261),
      body: Container(),
    );
  }
}