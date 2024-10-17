import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../widgets/drawer.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController civilStatusController = TextEditingController();
  final TextEditingController zoneController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  String? profilePicUrl;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userData.exists) {
        setState(() {
          firstNameController.text = userData['first_name'] ?? '';
          middleNameController.text = userData['middle_name'] ?? '';
          lastNameController.text = userData['last_name'] ?? '';
          birthdayController.text = userData['birthday'] ?? '';
          civilStatusController.text = userData['civil_status'] ?? '';
          zoneController.text = userData['zone'] ?? '';
          contactNumberController.text = userData['contact_number'] ?? '';
          profilePicUrl = userData['profile_pic'] ?? '';
        });
      }
    }
  }

  Future<void> _uploadProfilePicture() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (_image != null && user != null) {
      // Upload image to Firebase Storage
      String fileName = 'profile_pics/${user.uid}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(_image!);

      await uploadTask.whenComplete(() => null);

      // Get the download URL
      String downloadUrl = await storageRef.getDownloadURL();

      // Update Firestore with the new profile pic URL
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profile_pic': downloadUrl});

      setState(() {
        profilePicUrl = downloadUrl;
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _uploadProfilePicture();
    }
  }

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
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage, // Trigger image picker on tap
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: profilePicUrl != null &&
                          profilePicUrl!.isNotEmpty
                      ? NetworkImage(profilePicUrl!)
                      : AssetImage('images/lingkod_logo.png') as ImageProvider,
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
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
              // Add your update profile logic here
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
        keyboardType: labelText == 'Birthday'
            ? TextInputType.datetime
            : TextInputType.text,
        onTap: labelText == 'Birthday'
            ? () async {
                FocusScope.of(context)
                    .requestFocus(FocusNode()); // Hide keyboard
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    controller.text = pickedDate
                        .toLocal()
                        .toString()
                        .split(' ')[0]; // Format to YYYY-MM-DD
                  });
                }
              }
            : null,
      ),
    );
  }
}
