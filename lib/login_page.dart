// lib/screen/login_page.dart
import 'dart:io'; 
import 'dart:math' as math;
import 'package:flutter/material.dart';
// Sesuaikan path import ini ke lokasi auth_service.dart kamu
import '../service/auth_service.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  // --- Animation Controllers ---
  late AnimationController _entranceController;
  late AnimationController _orbitController;
  late final Animation<double> _circleAnim;
  
  // --- Logic & Input Variables ---
  bool _isAndroid = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final AuthService _authService = AuthService(); // Instance Service API

  @override
  void initState() {
    super.initState();
    
    // Cek OS (aman buat web/desktop juga krn try-catch)
    try {
      _isAndroid = Platform.isAndroid;
    } catch (e) {
      _isAndroid = false;
    }

    // 1. Controller Muncul (Entrance)
    _entranceController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _isAndroid ? 600 : 1000),
    )..forward();
    
    _circleAnim = CurvedAnimation(
      parent: _entranceController, 
      curve: _isAndroid ? Curves.easeOut : Curves.easeOutCubic,
    );

    // 2. Controller Orbit (Muter)
    // ANDROID: 25 Detik (Lambat banget biar gak pusing/berat)
    // IOS: 8 Detik (Agak cepet biar fancy)
    final int orbitDuration = _isAndroid ? 25 : 8;

    _orbitController = AnimationController(
      vsync: this,
      duration: Duration(seconds: orbitDuration),
    )..repeat(); // Muter terus selamanya
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _orbitController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- LOGIC LOGIN KE API LARAVEL ---
  Future<void> _handleLogin() async {
    // 1. Validasi Input
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email dan Password tidak boleh kosong!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 2. Mulai Loading
    setState(() => _isLoading = true);

    // 3. Panggil Service
    // Pastikan auth_service.dart sudah dibuat sesuai instruksi sebelumnya
    final result = await _authService.login(
      _emailController.text.trim(), 
      _passwordController.text.trim()
    );

    // 4. Selesai Loading
    if (!mounted) return;
    setState(() => _isLoading = false);

    // 5. Cek Hasil
    if (result['success']) {
      // Login Sukses -> Masuk Home
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Login Gagal -> Munculin Pesan Error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? "Login Gagal"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // --- WIDGET BUILDER ---

  Widget _buildAnimatedTitle() {
    const text = 'T-Book';
    
    if (_isAndroid) {
      return FadeTransition(
        opacity: _circleAnim,
        child: const Text(
          text,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
            decoration: TextDecoration.none,
          ),
        ),
      );
    }

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

  Widget _buildDecorationCircle({
    required double top,
    required double left,
    required double right,
    required double bottom,
    required double size,
    required bool isCounterClockwise,
  }) {
    return Positioned(
      top: top != 0 ? top : null,
      left: left != 0 ? left : null,
      right: right != 0 ? right : null,
      bottom: bottom != 0 ? bottom : null,
      child: AnimatedBuilder(
        animation: _orbitController,
        builder: (context, child) {
          double val = _orbitController.value;
          if (isCounterClockwise) val = -val;
          
          final angle = val * 2 * math.pi;
          final dx = 30 * math.cos(angle); 
          final dy = 30 * math.sin(angle);

          return Transform.translate(
            offset: Offset(dx, dy), 
            child: Opacity(
              opacity: _circleAnim.value,
              child: Transform.scale(
                scale: 0.8 + 0.2 * _circleAnim.value,
                child: Container(
                  width: size,
                  height: size,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    const cardBorderRadius = BorderRadius.all(Radius.circular(12));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- BACKGROUND BOLA ---
          _buildDecorationCircle(
            top: -100, left: -100, right: 0, bottom: 0, 
            size: 250, 
            isCounterClockwise: false
          ),
          _buildDecorationCircle(
            top: 0, left: 0, right: -60, bottom: -60, 
            size: 200, 
            isCounterClockwise: true
          ),

          // --- KONTEN UTAMA ---
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // LOGO 
                    Hero(
                      tag: "logo",
                       child: Image.asset(
                        'assets/t_book_logo.png',
                        height: 80,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // JUDUL 
                    _buildAnimatedTitle(),
                    
                    const SizedBox(height: 30),

                    // FORM INPUT
                    FadeTransition(
                      opacity: _circleAnim, 
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: cardBorderRadius,
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            // FIELD EMAIL
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined, color: Colors.orange),
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // FIELD PASSWORD
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock_outline, color: Colors.orange),
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // TOMBOL LOGIN
                    FadeTransition(
                      opacity: _circleAnim,
                      child: SizedBox(
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
                          // Jika lagi loading, disable tombol
                          onPressed: _isLoading ? null : _handleLogin,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24, 
                                  height: 24, 
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
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