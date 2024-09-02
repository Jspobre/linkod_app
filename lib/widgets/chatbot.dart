import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart'; // Import this for date formatting

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
    } else if (option == 'Business Permit') {
      _addChatMessage(_buildBusinessPermitForm());
    } else if (option == 'Certificate of Indigency') {
      _addChatMessage(_buildHouseholdRegistrationForm());
    } else if (option == 'Event Permit') {
      _addChatMessage(_buildHouseholdRegistrationForm());
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
        _addChatMessage(_buildHouseholdRegistrationForm());
      } else if (userMessage.toLowerCase() == 'submit blotter report') {
        // Handle Submit Blotter Report options
        _addChatMessage(_buildBlotterReportForm());
      } else if (userMessage.toLowerCase() == 'barangay clearance') {
        _addChatMessage(_buildBarangayClearanceForm());
      } else if (userMessage.toLowerCase() == 'business permit') {
        // Handle Household Registration options
        _addChatMessage(_buildBusinessPermitForm());
      } else if (userMessage.toLowerCase() == 'certificate of indigency') {
        // Handle Household Registration options
        _addChatMessage(_buildHouseholdRegistrationForm());
      } else if (userMessage.toLowerCase() == 'event permit') {
        // Handle Household Registration options
        _addChatMessage(_buildHouseholdRegistrationForm());
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
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController civilStatusController = TextEditingController();
    TextEditingController zoneController = TextEditingController();
    TextEditingController purposeController = TextEditingController();

    // Controller for gender dropdown
    String? selectedGender;

    return _buildChatBubble([
      Text(
        'Please provide the following information for barangay clearance:',
        style: TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      _buildTextField('Name', nameController),
      const SizedBox(height: 10),
      _buildTextField('Age', ageController),
      const SizedBox(height: 10),
      _buildDropdownField(
        // 'Gender',
        ['Male', 'Female', 'Other'],
        (value) {
          selectedGender = value;
        },
      ),
      const SizedBox(height: 10),
      _buildTextField('Civil Status', civilStatusController),
      const SizedBox(height: 10),
      _buildTextField('Zone', zoneController),
      const SizedBox(height: 10),
      _buildTextField('Purpose', purposeController),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          if (selectedGender == null) {
            Fluttertoast.showToast(
              msg: "Please select a gender",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            return;
          }

          _submitBarangayClearanceForm(
            nameController.text.trim(),
            ageController.text.trim(),
            selectedGender!,
            civilStatusController.text.trim(),
            zoneController.text.trim(),
            purposeController.text.trim(),
          );

          // Clear the text fields and reset dropdown after submission
          nameController.clear();
          ageController.clear();
          selectedGender = null;
          civilStatusController.clear();
          zoneController.clear();
          purposeController.clear();
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

  Widget _buildDropdownField(
    // String label,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   label,
        //   style: TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
          isExpanded: true,
          hint: Text('Select Gender'),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          ),
        ),
      ],
    );
  }

  void _submitBarangayClearanceForm(
    String fullName,
    String age,
    String gender,
    String civilStatus,
    String zone,
    String purpose,
  ) async {
    // Firebase Firestore and Auth instances
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      // Get the current user's UID
      String? uid = auth.currentUser?.uid;

      await firestore.collection('requests').add({
        'full_name': fullName,
        'status': 'Pending',
        'type': 'Barangay Clearance',
        'date_requested': FieldValue.serverTimestamp(),
        'uid': uid, // Add UID to the Firestore document
        'details': {
          'age': age,
          'gender': gender,
          'civil_status': civilStatus,
          'zone': zone,
          'purpose': purpose,
          // Additional fields can be added to details if needed
        },
      });

      // Show confirmation toast message
      Fluttertoast.showToast(
        msg: "Your Barangay Clearance request has been submitted successfully!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      // Handle error and show error toast message
      Fluttertoast.showToast(
        msg: "Failed to submit your request. Please try again later.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Widget _buildBusinessPermitForm() {
    TextEditingController nameController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController businessLocationController = TextEditingController();
    TextEditingController natureOfBusinessController = TextEditingController();
    TextEditingController businessStatusController = TextEditingController();
    TextEditingController permitNoController = TextEditingController();
    TextEditingController amountPaidController = TextEditingController();
    TextEditingController validUntilController = TextEditingController();

    return _buildChatBubble([
      Text(
        'Please provide the following information for the business permit:',
        style: TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      _buildTextField('Proprietor Name', nameController),
      const SizedBox(height: 10),
      _buildTextField('Address', addressController),
      const SizedBox(height: 10),
      _buildTextField('Business Location', businessLocationController),
      const SizedBox(height: 10),
      _buildTextField('Nature of Business', natureOfBusinessController),
      const SizedBox(height: 10),
      _buildTextField('Status', businessStatusController),
      const SizedBox(height: 10),
      _buildTextField('Permit Number', permitNoController),
      const SizedBox(height: 10),
      _buildTextField('Amount Paid', amountPaidController),
      const SizedBox(height: 10),
      GestureDetector(
        onTap: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (selectedDate != null) {
            // Format the date to "August 22, 2024"
            String formattedDate =
                DateFormat('MMMM d, yyyy').format(selectedDate);
            validUntilController.text = formattedDate;
          }
        },
        child: AbsorbPointer(
          child: _buildTextField('Valid Until', validUntilController),
        ),
      ),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          _submitBusinessPermitForm(
            nameController.text.trim(),
            addressController.text.trim(),
            businessLocationController.text.trim(),
            natureOfBusinessController.text.trim(),
            businessStatusController.text.trim(),
            permitNoController.text.trim(),
            double.tryParse(amountPaidController.text.trim()) ?? 0.0,
            validUntilController.text.trim(),
          );

          // Clear the text fields after submission
          nameController.clear();
          addressController.clear();
          businessLocationController.clear();
          natureOfBusinessController.clear();
          businessStatusController.clear();
          permitNoController.clear();
          amountPaidController.clear();
          validUntilController.clear();
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

  void _submitBusinessPermitForm(
    String proprietor,
    String address,
    String businessLocation,
    String natureOfBusiness,
    String status,
    String permitNo,
    double amountPaid,
    String validUntil,
  ) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      // Get the current user's UID
      String? uid = auth.currentUser?.uid;

      // Parse the date back from the formatted string
      DateTime validUntilDate = DateFormat('MMMM d, yyyy').parse(validUntil);

      await firestore.collection('requests').add({
        'full_name': proprietor,
        'address': address,
        'status': 'pending',
        'type': 'Business Permit',
        'date_requested': FieldValue.serverTimestamp(),
        'uid': uid, // Add UID to the Firestore document
        'details': {
          'business_location': businessLocation,
          'nature_of_business': natureOfBusiness,
          'permit_no': permitNo,
          'proprietor': proprietor,
          'amount_paid': amountPaid,
          'status': status,
          'valid_until':
              Timestamp.fromDate(validUntilDate), // Adjusted for Firestore
        },
      });

      // Show confirmation toast message
      Fluttertoast.showToast(
        msg: "Your Business Permit request has been submitted successfully!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      // Handle error and show error toast message
      Fluttertoast.showToast(
        msg: "Failed to submit your request. Please try again later.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    void Function()? onTap,
    bool readOnly = false,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
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

    List<Map<String, String>> members = [];

    return StatefulBuilder(
      builder: (context, setState) {
        return _buildChatBubble([
          Text(
            'Please provide the following information for Household Registration:',
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildTextField('Household Head', householdHeadController),
          const SizedBox(height: 10),
          _buildTextField('Address', addressController),
          const SizedBox(height: 10),
          _buildTextField('Number of Members', numOfMembersController),
          const SizedBox(height: 10),
          ...members
              .asMap()
              .entries
              .map(
                (entry) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Member ${entry.key + 1}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    _buildTextField(
                      'Member Name',
                      TextEditingController(
                        text: entry.value['name'],
                      ),
                      onChanged: (value) {
                        setState(() {
                          members[entry.key]['name'] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      'Member Age',
                      TextEditingController(
                        text: entry.value['age'],
                      ),
                      onChanged: (value) {
                        setState(() {
                          members[entry.key]['age'] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              )
              .toList(),
          ElevatedButton(
            onPressed: () {
              setState(() {
                members.add({'name': '', 'age': ''});
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Add Member',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _submitHouseholdRegistrationForm(
                householdHeadController.text.trim(),
                addressController.text.trim(),
                numOfMembersController.text.trim(),
                contactNumberController.text.trim(),
                members,
              );

              // Clear the form fields
              householdHeadController.clear();
              addressController.clear();
              numOfMembersController.clear();
              contactNumberController.clear();
              members.clear();
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
      },
    );
  }

  void _submitHouseholdRegistrationForm(
    String householdHead,
    String address,
    String numOfMembers,
    String contactNumber,
    List<Map<String, String>> members,
  ) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser; // Get the current user

    try {
      await firestore.collection('household_registrations').add({
        'household_head': householdHead,
        'address': address,
        'number_of_members': numOfMembers,
        'contact_number': contactNumber,
        'members': members,
        'user_uid': user?.uid, // Include UID
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show success toast
      Fluttertoast.showToast(
        msg: "Your Household Registration has been submitted successfully!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

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
      // Show error toast
      Fluttertoast.showToast(
        msg: "Failed to submit your registration. Please try again later.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

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
    TextEditingController whatController = TextEditingController();
    TextEditingController whereController = TextEditingController();
    TextEditingController whenController = TextEditingController();
    TextEditingController whyController = TextEditingController();
    TextEditingController howController = TextEditingController();
    TextEditingController complainantController = TextEditingController();

    return _buildChatBubble([
      Text(
        'Please provide the following information for the Blotter Report:',
        style: TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      _buildTextField('What', whatController),
      const SizedBox(height: 10),
      _buildTextField('Where', whereController),
      const SizedBox(height: 10),
      _buildTextField(
        'When',
        whenController,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            setState(() {
              whenController.text =
                  DateFormat('MMMM dd, yyyy').format(pickedDate);
            });
          }
        },
        readOnly: true,
      ),
      const SizedBox(height: 10),
      _buildTextField('Why', whyController),
      const SizedBox(height: 10),
      _buildTextField('How', howController),
      const SizedBox(height: 10),
      _buildTextField('Complainant', complainantController),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          _submitBlotterReportForm(
            whatController.text.trim(),
            whereController.text.trim(),
            whenController.text.trim(),
            whyController.text.trim(),
            howController.text.trim(),
            complainantController.text.trim(),
          );
          // Clear the form fields
          setState(() {
            whatController.clear();
            whereController.clear();
            whenController.clear();
            whyController.clear();
            howController.clear();
            complainantController.clear();
          });
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
    String what,
    String where,
    String when,
    String why,
    String how,
    String complainant,
  ) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    DateTime now = DateTime.now();
    String reportedDate = DateFormat('MMMM dd, yyyy').format(now);
    String reportedTime = DateFormat('hh:mm a').format(now);
    String? uid = auth.currentUser?.uid;
    try {
      await firestore.collection('blotter_reports').add({
        'reported_date': reportedDate,
        'reported_time': reportedTime,
        'what': what,
        'where': where,
        'when': when,
        'why': why,
        'how': how,
        'complainant': complainant,
        'uid': uid,
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

      Fluttertoast.showToast(
        msg: "Blotter Report submitted successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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

      Fluttertoast.showToast(
        msg: "Failed to submit Blotter Report.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
