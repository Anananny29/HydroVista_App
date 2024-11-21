import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/upload_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hydro Vista App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 243, 241, 222), // Global background color
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/upload': (context) => const UploadPage(),
      },
    );
  }
}
