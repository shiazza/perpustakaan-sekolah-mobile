import 'package:flutter/material.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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
              parent: _controller,
              curve: Interval(delay, delay + 0.5, curve: Curves.easeOutCubic),
            ),
          );
          final fadeAnim = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(delay, delay + 0.4, curve: Curves.easeIn),
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
          // Bola gradasi kiri atas
          Positioned(
            top: -100,
            left: -100,
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
          // Bola gradasi kanan bawah
          Positioned(
            bottom: -60,
            right: -60,
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
          // Konten utama
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text("Don't have account "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 600),
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const RegisterPage(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        final fade = Tween(begin: 0.0, end: 1.0)
                                            .animate(animation);
                                        return FadeTransition(
                                          opacity: fade,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          )
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
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 16),
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
