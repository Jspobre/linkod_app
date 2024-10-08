import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkod_app/firebase_options.dart';
import 'package:linkod_app/pages/homePage.dart';
import './pages/loginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: "linkod_app", options: DefaultFirebaseOptions.currentPlatform);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          '@mipmap/launcher_icon'); // The converted icon file

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
        textTheme: GoogleFonts.poppinsTextTheme(),
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
