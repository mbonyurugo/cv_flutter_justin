import 'package:flutter/material.dart';
import 'login.dart';


void main() {
  runApp(const CvFlutterJustinApp());
}

class CvFlutterJustinApp extends StatelessWidget {
  const CvFlutterJustinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV Flutter Justin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0284C7)),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}