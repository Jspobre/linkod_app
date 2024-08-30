import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './pages/loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Landing Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF312E81),
          primary: Color(0xFF312E81), // Set primary color to match background
          secondary: Color(
              0xFF312E81), // Optional: set secondary color to match background
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Color.fromARGB(255, 28, 25, 106),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 28, 25, 106),
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        child: Center(
          child: Image.asset(
            'images/lingkod_logo.png',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
