import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatBot extends StatefulWidget {
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  bool _isChatOpen = false;
  List<Widget> _chatMessages = [];
  TextEditingController _messageController = TextEditingController();

  void _addChatMessage(Widget message) {
    setState(() {
      _chatMessages.add(message);
    });
  }

  void _showBarangayDocOptions() {
    _addChatMessage(
      _buildChatBubble(
        [
          Text(
            'Request Barangay Document',
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildChatOption('Certificate of Indigency'),
          SizedBox(height: 10),
          _buildChatOption('Business Permit'),
          SizedBox(height: 10),
          _buildChatOption('Barangay Clearance'),
          SizedBox(height: 10),
          _buildChatOption('Event Permit'),
        ],
      ),
    );
  }

  void _handleOptionTap(String option) {
    _addChatMessage(
      _buildUserChatBubble(option), // Add user message
    );
    // Show additional options for the selected option
    if (option == 'Request Barangay Documents') {
      _addChatMessage(
        _buildChatBubble(
          [
            SizedBox(height: 10),
            _buildChatOption('Certificate of Indigency'),
            SizedBox(height: 10),
            _buildChatOption('Business Permit'),
            SizedBox(height: 10),
            _buildChatOption('Barangay Clearance'),
            SizedBox(height: 10),
            _buildChatOption('Event Permit'),
          ],
        ),
      );
    }
    if (option == 'Barangay Clearance') {
      _addChatMessage(_buildBarangayClearanceForm());
    } else if (option == 'Household Registration') {
      _addChatMessage(_buildHouseholdRegistrationForm());
    } else if (option == 'Submit Blotter Report') {
      _addChatMessage(_buildBlotterReportForm());
    }
  }

  void _handleSendMessage() {
    String userMessage = _messageController.text.trim();
    if (userMessage.isNotEmpty) {
      _addChatMessage(
        _buildUserChatBubble(userMessage),
      );

      // Clear the input field
      _messageController.clear();

      // Show additional options based on the input
      if (userMessage.toLowerCase() == 'request barangay documents') {
        _showBarangayDocOptions();
      } else if (userMessage.toLowerCase() == 'household registration') {
        // Handle Household Registration options
        _addChatMessage(
          _buildChatBubble(
            [
              Text(
                'Household Registration',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Add more options if necessary
            ],
          ),
        );
      } else if (userMessage.toLowerCase() == 'submit blotter report') {
        // Handle Submit Blotter Report options
        _addChatMessage(
          _buildChatBubble(
            [
              Text(
                'Submit Blotter Report',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Add more options if necessary
            ],
          ),
        );
      } else if (userMessage.toLowerCase() == 'barangay clearance') {
        _addChatMessage(_buildBarangayClearanceForm());
      }
    }
  }

  Widget _buildChatOption(String title) {
    return ElevatedButton(
      onPressed: () {
        _handleOptionTap(title);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildChatBubble(List<Widget> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.android,
            size: 40,
            color: Colors.black,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: options,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserChatBubble(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(width: 10),
          Icon(
            Icons.person, // User icon
            size: 40,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton.extended(
            onPressed: () {
              setState(() {
                _isChatOpen = !_isChatOpen;
              });
            },
            backgroundColor: Colors.deepPurple,
            icon: Icon(
              _isChatOpen ? Icons.close : Icons.chat,
              color: Colors.white,
            ),
            label: Text(
              'Chat Now!',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        if (_isChatOpen)
          Positioned(
            bottom: 80,
            right: 20,
            left: 20,
            child: Material(
              color: Colors.white,
              elevation: 8.0,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Adjust width
                height: 400,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Chat with us!',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildChatBubble(
                            [
                              Text(
                                'Main Menu',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              _buildChatOption('Request Barangay Documents'),
                              SizedBox(height: 10),
                              _buildChatOption('Household Registration'),
                              SizedBox(height: 10),
                              _buildChatOption('Submit Blotter Report'),
                            ],
                          ),
                          ..._chatMessages,
                        ],
                      ),
                    ),
                    TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send, color: Colors.deepPurple),
                          onPressed: _handleSendMessage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

// for barangay clearance document
  Widget _buildBarangayClearanceForm() {
    // TextEditingController nameController = TextEditingController();
    // TextEditingController ageController = TextEditingController();
    // TextEditingController civilStatusController = TextEditingController();
    // TextEditingController zoneController = TextEditingController();
    TextEditingController purposeController = TextEditingController();

    return _buildChatBubble([
      Text(
        'Please provide the following information for barangay clearance:',
        style: TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      // _buildTextField('Name', nameController),
      // _buildTextField('Age', ageController),
      // _buildTextField('Civil Status', civilStatusController),
      // _buildTextField('Zone', zoneController),
      _buildTextField('Purpose', purposeController),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          _submitBarangayClearanceForm(
              // nameController.text.trim(),
              // ageController.text.trim(),
              // civilStatusController.text.trim(),
              // zoneController.text.trim(),
              purposeController.text.trim());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Submit',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ]);
  }

  void _submitBarangayClearanceForm(
    // String name,
    // String age,
    // String civilStatus,
    // String zone,
    String purpose,
  ) async {
    // Firebase Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('barangay_clearance_requests').add({
        // 'name': name,
        // 'age': age,
        // 'civil_status': civilStatus,
        // 'zone': zone,
        'purpose': purpose,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show confirmation message in the chat
      _addChatMessage(_buildChatBubble([
        Text(
          'Your Barangay Clearance request has been submitted successfully!',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]));
    } catch (e) {
      // Handle error and show message in the chat
      _addChatMessage(_buildChatBubble([
        Text(
          'Failed to submit your request. Please try again later.',
          style: TextStyle(
            color: Colors.red,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]));
    }
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // Household registration form
  Widget _buildHouseholdRegistrationForm() {
    TextEditingController householdHeadController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController numOfMembersController = TextEditingController();
    TextEditingController contactNumberController = TextEditingController();

    return _buildChatBubble([
      Text(
        'Please provide the following information for Household Registration:',
        style: TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      _buildTextField('Household Head', householdHeadController),
      _buildTextField('Address', addressController),
      _buildTextField('Number of Members', numOfMembersController),
      _buildTextField('Contact Number', contactNumberController),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          _submitHouseholdRegistrationForm(
            householdHeadController.text.trim(),
            addressController.text.trim(),
            numOfMembersController.text.trim(),
            contactNumberController.text.trim(),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Submit',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ]);
  }

  void _submitHouseholdRegistrationForm(
    String householdHead,
    String address,
    String numOfMembers,
    String contactNumber,
  ) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('household_registrations').add({
        'household_head': householdHead,
        'address': address,
        'number_of_members': numOfMembers,
        'contact_number': contactNumber,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _addChatMessage(_buildChatBubble([
        Text(
          'Your Household Registration has been submitted successfully!',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]));
    } catch (e) {
      _addChatMessage(_buildChatBubble([
        Text(
          'Failed to submit your registration. Please try again later.',
          style: TextStyle(
            color: Colors.red,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]));
    }
  }

// BLOTTER FORM
  Widget _buildBlotterReportForm() {
    TextEditingController complainantNameController = TextEditingController();
    TextEditingController respondentNameController = TextEditingController();
    TextEditingController incidentDetailsController = TextEditingController();
    TextEditingController incidentLocationController = TextEditingController();
    TextEditingController incidentDateController = TextEditingController();

    return _buildChatBubble([
      Text(
        'Please provide the following information for the Blotter Report:',
        style: TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      _buildTextField('Complainant Name', complainantNameController),
      _buildTextField('Respondent Name', respondentNameController),
      _buildTextField('Incident Details', incidentDetailsController),
      _buildTextField('Incident Location', incidentLocationController),
      _buildTextField('Incident Date', incidentDateController),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          _submitBlotterReportForm(
            complainantNameController.text.trim(),
            respondentNameController.text.trim(),
            incidentDetailsController.text.trim(),
            incidentLocationController.text.trim(),
            incidentDateController.text.trim(),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Submit',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ]);
  }

  void _submitBlotterReportForm(
    String complainantName,
    String respondentName,
    String incidentDetails,
    String incidentLocation,
    String incidentDate,
  ) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('blotter_reports').add({
        'complainant_name': complainantName,
        'respondent_name': respondentName,
        'incident_details': incidentDetails,
        'incident_location': incidentLocation,
        'incident_date': incidentDate,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _addChatMessage(_buildChatBubble([
        Text(
          'Your Blotter Report has been submitted successfully!',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]));
    } catch (e) {
      _addChatMessage(_buildChatBubble([
        Text(
          'Failed to submit your report. Please try again later.',
          style: TextStyle(
            color: Colors.red,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]));
    }
  }
}
