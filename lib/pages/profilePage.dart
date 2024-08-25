import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class ProfilePage extends StatelessWidget {
  final TextEditingController firstNameController =
      TextEditingController(text: 'John');
  final TextEditingController middleNameController =
      TextEditingController(text: 'Doe');
  final TextEditingController lastNameController =
      TextEditingController(text: 'Smith');
  final TextEditingController birthdayController =
      TextEditingController(text: '01/01/1990');
  final TextEditingController civilStatusController =
      TextEditingController(text: 'Single');
  final TextEditingController zoneController =
      TextEditingController(text: 'Zone 5');
  final TextEditingController contactNumberController =
      TextEditingController(text: '+1234567890');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 28, 25, 106),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 28, 25, 106),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'images/lingkod_logo.png', // Path to your logo
                height: 100, // Adjust the size of the logo
              ),
              SizedBox(height: 20),
              Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField('First Name', firstNameController),
              _buildTextField('Middle Name', middleNameController),
              _buildTextField('Last Name', lastNameController),
              _buildTextField('Birthday', birthdayController),
              _buildTextField('Civil Status', civilStatusController),
              _buildTextField('Zone', zoneController),
              _buildTextField('Contact Number', contactNumberController),
              SizedBox(height: 20),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.white,
              //     foregroundColor: Color(0xFF312E81),
              //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //   ),
              //   onPressed: () {
              //     // Add your update profile logic here
              //   },
              //   child: Text(
              //     'Update Profile',
              //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
