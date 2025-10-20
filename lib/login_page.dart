import 'package:flutter/material.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                const Hero(
                  tag: "title",
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      'T-Book',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Input Form
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
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
                                    final fade = Tween(
                                            begin: 0.0, end: 1.0)
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

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login Clicked')),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}