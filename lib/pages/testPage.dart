import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters

class SignupPageTest extends StatefulWidget {
  @override
  _SignupPageTestState createState() => _SignupPageTestState();
}

class _SignupPageTestState extends State<SignupPageTest> {
  final PageController _pageController = PageController();

  // Controllers for each form field
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  // Variables to store image paths or files for upload
  // For example: File _profilePic, _validId;
  // But using Strings for simplicity in this example

  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _submitForm() {
    // Gather all the data from the form fields
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final age = _ageController.text;
    final birthday = _birthdayController.text;

    // For image paths:
    // final profilePic = _profilePic.path;
    // final validId = _validId.path;

    // Here you would typically send this data to your backend or handle it as needed
    print("First Name: $firstName");
    print("Last Name: $lastName");
    print("Email: $email");
    print("Password: $password");
    print("Age: $age");
    print("Birthday: $birthday");

    // Clear the controllers after submission
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _ageController.clear();
    _birthdayController.clear();

    // Navigate to a different screen or show a confirmation message
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Form Submitted Successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: PageView(
        controller: _pageController,
        physics:
            NeverScrollableScrollPhysics(), // Prevent swiping between pages
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          // Page 1: Basic Info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    child: Text('Next'),
                  ),
                ),
              ],
            ),
          ),

          // Page 2: Additional Info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _birthdayController,
                  decoration: InputDecoration(
                    labelText: 'Birthday',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      _birthdayController.text =
                          pickedDate.toString().substring(0, 10);
                    }
                  },
                  readOnly: true,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _previousPage,
                      child: Text('Previous'),
                    ),
                    ElevatedButton(
                      onPressed: _nextPage,
                      child: Text('Next'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Page 3: Image Upload
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Upload Profile Picture'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Implement image picker logic here
                  },
                  child: Text('Choose Profile Picture'),
                ),
                SizedBox(height: 16),
                Text('Upload Valid ID'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Implement image picker logic here
                  },
                  child: Text('Choose Valid ID'),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _previousPage,
                      child: Text('Previous'),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
