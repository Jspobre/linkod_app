import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import './signupPage.dart';
import './homePage.dart';
import './forgotPassword.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import fluttertoast
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<void> _signIn() async {
  //   try {
  //     // Get the user's email from the input field
  //     String email = _emailController.text.trim();

  //     // Query Firestore to check the user's status
  //     DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //         .collection('users') // Replace 'users' with your collection name
  //         .doc(email)
  //         .get();

  //     if (userDoc.exists) {
  //       // Check if the status is 'approved'
  //       String status = userDoc.get('status');
  //       if (status == 'approved') {
  //         // Status is approved, proceed with sign-in
  //         UserCredential userCredential =
  //             await _auth.signInWithEmailAndPassword(
  //           email: email,
  //           password: _passwordController.text.trim(),
  //         );
  //         print('Signed in: ${userCredential.user!.uid}');
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => HomePage()),
  //         );
  //       } else {
  //         // Status is not approved, show an error message using Flutter toast
  //         Fluttertoast.showToast(
  //           msg: 'Your account has not been approved yet.',
  //           toastLength: Toast.LENGTH_LONG,
  //           gravity: ToastGravity.BOTTOM,
  //         );
  //       }
  //     } else {
  //       // User document does not exist, show an error message using Flutter toast
  //       Fluttertoast.showToast(
  //         msg: 'No account found with this email.',
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.BOTTOM,
  //       );
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     // Show a general error message using Flutter toast
  //     Fluttertoast.showToast(
  //       msg: 'Failed to sign in: $e',
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.BOTTOM,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 28, 25, 106),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 25, 106),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'images/lingkod_logo.png',
                  width: 170,
                  height: 170,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Login',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: 350,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.email, color: Colors.deepPurpleAccent),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
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
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 350,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.lock, color: Colors.deepPurpleAccent),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
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
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 370,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage()),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  // onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text('Login',
                      style: GoogleFonts.poppins(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: GoogleFonts.poppins(color: Colors.white),
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
                      style:
                          GoogleFonts.poppins(color: Colors.deepPurpleAccent),
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
