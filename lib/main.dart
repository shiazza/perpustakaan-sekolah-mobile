import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'screen/home/home.dart'; 


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'T_Book',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
         '/home': (context) => HomePage(), 
      },
    );
  }
}