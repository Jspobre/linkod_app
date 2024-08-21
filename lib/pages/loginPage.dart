import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './signupPage.dart';
import './homePage.dart';
import './forgotPassword.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color(0xFF312E81), // Matches the background color
        elevation: 0, // Remove the shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFF312E81), // Background color
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Align center
            children: <Widget>[
              // Logo at the top
              Center(
                child: Image.asset(
                  'images/lingkod_logo.png', // Make sure this path is correct
                  width: 170,
                  height: 170,
                ),
              ),
              const SizedBox(height: 20),

              // Login Text
              Center(
                child: Text(
                  'Login',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Email Field with specific width
              Container(
                width: 350, // Set your desired width here
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.email, color: Colors.deepPurpleAccent),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email',
                    hintStyle: GoogleFonts.roboto(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 20.0),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                          color: Colors.deepPurpleAccent, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 1.0),
                    ),
                  ),
                  style: GoogleFonts.roboto(color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),

              // Password Field with specific width
              Container(
                width: 350, // Set your desired width here
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.lock, color: Colors.deepPurpleAccent),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    hintStyle: GoogleFonts.roboto(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 20.0),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                          color: Colors.deepPurpleAccent, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 1.0),
                    ),
                  ),
                  style: GoogleFonts.roboto(color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),

              // Forgot Password
              Container(
                width: 370,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()));
                    },
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.roboto(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Login Button
              Container(
                width: 250, // Set your desired width here
                child: ElevatedButton(
                  onPressed: () {
                    // Implement login functionality
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text('Login',
                      style: GoogleFonts.roboto(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),

              // Signup Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: GoogleFonts.roboto(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                    child: Text(
                      'Sign up',
                      style: GoogleFonts.roboto(color: Colors.deepPurpleAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
