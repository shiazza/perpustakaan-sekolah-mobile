import 'package:flutter/material.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
               Image.asset(
                  'assets/t_book_logo.png',
                  height: 120,
                ),
                const SizedBox(height: 20),
                const Text(
                  'T-Book',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 30),

                  // Card Box
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        
                        // nama field
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // email field
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // Password field
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Link ke halaman Login
                      Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                           MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

                const SizedBox(height: 24),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // aksi register
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}