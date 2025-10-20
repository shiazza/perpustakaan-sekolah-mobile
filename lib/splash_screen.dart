// lib/splash_screen.dart
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
  late Animation<double> _logoScale;    // logo scale bounce
  late Animation<double> _titleScale;   // title scale (slight)
  late Animation<double> _titleFade;    // title fade (clamped 0..1)

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Logo: kuat bounce dari awal (0.0 - 0.8)
    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Title scale: mulai sedikit delay (0.25 - 1.0) dengan easeOutBack
    _titleScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.7, curve: Curves.easeOutBack),
      ),
    );

    // Title fade: mulai sedikit delay (0.2 - 1.0) ensure 0..1
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.4, curve: Curves.easeIn),
      ),
    );

    // start animation
    _controller.forward();

    // move to login after 3s (kecepatan transisi fade 0.8s kamu minta sebelumnya;
    // di sini route fade duration 500ms — feel free to adjust)
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // safe fade 0..1
            return FadeTransition(
              opacity: animation.drive(Tween(begin: 0.0, end: 1.0)),
              child: child,
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
      child: AnimatedBuilder(
        animation: _logoScale,
        builder: (context, child) {
          // scale is guaranteed between 0.7..1.0
          return Transform.scale(
            scale: _logoScale.value,
            child: child,
          );
        },
        child: Image.asset(
          'assets/t_book_logo.png',
          width: 120,
          height: 120,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Hero(
      tag: "title",
      child: AnimatedBuilder(
        animation: Listenable.merge([_titleScale, _titleFade]),
        builder: (context, child) {
          // titleScale in 0.85..1 and titleFade in 0..1
          final scale = _titleScale.value;
          final opacity = _titleFade.value.clamp(0.0, 1.0);
          return Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          );
        },
        child: const Material(
          color: Colors.transparent,
          child: Text(
            'T-Book',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF4A261),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(),
              const SizedBox(height: 20),
              _buildTitle(),
            ],
          ),
        ),
      ),
    );
  }
}