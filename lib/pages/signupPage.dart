import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import './loginPage.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:fluttertoast/fluttertoast.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _civilStatusController = TextEditingController();
  final TextEditingController _zoneController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedCivilStatus;

  // final List<String> _civilStatuses = [
  //   'Single',
  //   'Married',
  //   'Divorced',
  //   'Widowed'
  // ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthdayController.text =
            DateFormat('MMMM d, yyyy').format(_selectedDate!);
      });
    }
  }

  String? _fileName;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _fileName = result.files.single.name;
      });
    }
  }

  Future<void> signUp() async {
    try {
      // Assume you have some Firebase authentication logic here
      // Example:
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Additional logic like saving user details to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'first_name': _firstNameController.text.trim(),
        'middle_name': _middleNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'birthday': _birthdayController.text.trim(),
        'age': _ageController.text.trim(),
        'civil_status': _civilStatusController.text.trim(),
        'zone': _zoneController.text.trim(),
        // Add other fields as needed
      });

      // Show success toast
      Fluttertoast.showToast(
        msg: "Signup successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      // Handle error (optional)
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 25, 106),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 25, 106),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'images/lingkod_logo.png',
                  width: 130,
                  height: 130,
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Create New Account',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 350,
                  child: Column(
                    children: [
                      TextField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'First Name',
                          prefixIcon: Icon(Icons.person, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _middleNameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Middle Name',
                          prefixIcon: Icon(Icons.person, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Last Name',
                          prefixIcon: Icon(Icons.person, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller:
                            _birthdayController, // Changed from _lastNameController
                        readOnly: true, // Makes the TextField non-editable
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Birthday',
                          prefixIcon: Icon(Icons.cake,
                              color: Colors
                                  .grey), // Changed icon to represent birthday
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2101),
                          );

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('MMMM dd, yyyy').format(pickedDate);
                            _birthdayController.text =
                                formattedDate; // Set the selected date to the text field
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Age',
                          prefixIcon: Icon(Icons.person, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.person, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                        hint: Text(
                            'Civil status'), // Use the hint property for placeholder
                        value: _selectedCivilStatus,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCivilStatus = newValue!;
                          });
                        },
                        items: <String>[
                          'Single',
                          'Married',
                          'Divorced',
                          'Widowed'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Zone',
                          prefixIcon: Icon(Icons.person, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      // File upload button
                      ElevatedButton(
                        onPressed: _pickFile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 20.0), // Added horizontal padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize
                              .min, // Adjusts to the size of its children
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Centers the content horizontally
                          children: [
                            Icon(
                              Icons.attach_file, // Icon to represent file
                              color: Colors.grey,
                            ),
                            const SizedBox(
                                width: 10), // Space between the icon and text
                            Text(
                              _fileName == null
                                  ? 'Upload Valid ID'
                                  : 'File: $_fileName',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 99, 92, 92)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      // Call your sign-up function here
                      // _signUp();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Sign Up',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.deepPurpleAccent),
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
