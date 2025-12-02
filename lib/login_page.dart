import 'dart:math' as math; // 1. Perlu import ini untuk rumus sin/cos
import 'package:flutter/material.dart';
// Hapus import register_page jika belum ada filenya, atau biarkan jika ada.
// import 'register_page.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  // Gunakan TickerProviderStateMixin karena kita punya lebih dari 1 controller
  
  late AnimationController _entranceController; // Controller untuk animasi muncul (Scale/Fade)
  late AnimationController _orbitController;    // Controller untuk animasi berputar (Orbit)
  late final Animation<double> _circleAnim;

  @override
  void initState() {
    super.initState();

    // 1. Controller untuk animasi pembuka (munculnya bola)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    
    _circleAnim = CurvedAnimation(
      parent: _entranceController, 
      curve: Curves.easeOutCubic
    );

    // 2. Controller untuk animasi berputar (Orbit) - Berjalan selamanya
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 13), // 13 detik untuk 1 putaran penuh (Slow)
    )..repeat(); // .repeat() agar berputar terus tanpa henti
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _orbitController.dispose(); // Jangan lupa dispose
    super.dispose();
  }

  Widget _buildAnimatedTitle() {
    const text = 'T-Book';
    return Hero(
      tag: "title",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(text.length, (i) {
          final delay = i * 0.1;
          final offsetAnim = Tween<Offset>(
            begin: const Offset(0, 0.5),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _entranceController,
              curve: Interval(delay, delay + 0.5, curve: Curves.easeOutCubic),
            ),
          );
          final fadeAnim = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: _entranceController,
              curve: Interval(delay, delay + 0.4, curve: Curves.easeIn),
            ),
          );
          return AnimatedBuilder(
            animation: _entranceController,
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
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                decoration: TextDecoration.none,
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const cardBorderRadius = BorderRadius.all(Radius.circular(12));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- BOLA GRADASI KIRI ATAS ---
          Positioned(
            top: -100,
            left: -100,
            child: AnimatedBuilder(
              // Kita listen ke orbitController untuk gerakan memutar
              animation: _orbitController,
              builder: (context, child) {
                // Rumus Orbit: Menggunakan Sin & Cos
                // Radius 30 piksel berputar mengelilingi titik awal (-100, -100)
                final angle = _orbitController.value * 2 * math.pi;
                final dx = 30 * math.cos(angle); 
                final dy = 30 * math.sin(angle);

                return Transform.translate(
                  offset: Offset(dx, dy), // Menggerakkan posisi X/Y
                  child: Opacity(
                    opacity: _circleAnim.value,
                    child: Transform.scale(
                      scale: 0.8 + 0.2 * _circleAnim.value,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [Color(0xFFFFB347), Colors.white],
                            radius: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // --- BOLA GRADASI KANAN BAWAH ---
          Positioned(
            bottom: -60,
            right: -60,
            child: AnimatedBuilder(
              animation: _orbitController,
              builder: (context, child) {
                // Agar variatif, bola bawah berputar berlawanan arah (minus angle)
                final angle = -_orbitController.value * 2 * math.pi;
                final dx = 30 * math.cos(angle);
                final dy = 30 * math.sin(angle);

                return Transform.translate(
                  offset: Offset(dx, dy),
                  child: Opacity(
                    opacity: _circleAnim.value,
                    child: Transform.scale(
                      scale: 0.8 + 0.2 * _circleAnim.value,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [Color(0xFFFFB347), Colors.white],
                            radius: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // --- KONTEN UTAMA ---
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: "logo",
                       child: Image.asset(
                        'assets/t_book_logo.png',
                        height: 80,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildAnimatedTitle(),
                    const SizedBox(height: 30),

                    // Form login
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: cardBorderRadius,
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Tombol login
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // Pastikan route '/home' sudah didaftarkan di main.dart
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}