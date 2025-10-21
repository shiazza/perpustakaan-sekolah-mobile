import 'package:flutter/material.dart';
import 'dart:async';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

 @override
void initState() {
  super.initState();

  _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  // Tambahkan delay sebelum animasi dimulai
  Future.delayed(const Duration(milliseconds: 1500), () {
    _controller.forward();
  });

  Timer(const Duration(seconds: 3), () {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fade = Tween(begin: 0.0, end: 1.0).animate(animation);
          final slideUp = Tween<Offset>(
            begin: const Offset(0, 0.2),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ));
          return FadeTransition(
            opacity: fade,
            child: SlideTransition(position: slideUp, child: child),
          );
        },
      ),
    );
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
          final offsetAnim = Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(delay, delay + 0.4, curve: Curves.easeOutBack),
            ),
          );
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