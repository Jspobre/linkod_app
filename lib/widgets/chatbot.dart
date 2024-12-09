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
  final ScrollController _scrollController = ScrollController();

  void _addChatMessage(Widget message) {
    setState(() {
      _chatMessages.add(message);
    });

    Future.delayed(
      Duration(seconds: 1),
      () {
        _scrollToBottom();
      },
    );
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
      _addChatMessage(_buildBarangayIndigencyForm());
    } else if (option == 'Event Permit') {
      _addChatMessage(_buildEventPermitForm());
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
        _addChatMessage(_buildBarangayIndigencyForm());
      } else if (userMessage.toLowerCase() == 'event permit') {
        // Handle Household Registration options
        _addChatMessage(_buildEventPermitForm());
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
                  color: const Color.fromARGB(255, 42, 8, 163),
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

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
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
                        controller: _scrollController,
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
    String? selectedCivilStatus;

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
        hintText: 'Select Gender',
        items: ['Male', 'Female', 'Other'],
        onChanged: (value) {
          selectedGender = value;
        },
      ),
      const SizedBox(height: 10),
      _buildDropdownField(
        hintText: 'Select Civil Status',
        items: [
          'Single',
          'Married',
          'Divorced',
          'Widowed',
          'Separated',
          'Annulled'
        ],
        onChanged: (value) {
          selectedCivilStatus = value;
        },
      ),
      const SizedBox(height: 10),
      _buildTextField('Zone', zoneController),
      const SizedBox(height: 10),
      _buildTextField('Purpose', purposeController),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          if (selectedGender == null ||
              nameController.text.isEmpty ||
              ageController.text.isEmpty ||
              zoneController.text.isEmpty ||
              purposeController.text.isEmpty) {
            // Fluttertoast.showToast(
            //   msg: "Please select a gender",
            //   toastLength: Toast.LENGTH_LONG,
            //   gravity: ToastGravity.BOTTOM,
            //   backgroundColor: const Color.fromARGB(255, 162, 51, 43),
            //   textColor: Colors.white,
            //   fontSize: 16.0,
            // );
            return;
          }

          _submitBarangayClearanceForm(
            nameController.text.trim(),
            ageController.text.trim(),
            selectedGender!,
            // civilStatusController.text.trim(),
            selectedCivilStatus!,
            zoneController.text.trim(),
            purposeController.text.trim(),
          );

          _addChatMessage(_buildChatBubble([
            Text(
                "Thank you. Your request for a barangay clearance has been submitted. You will receive a confirmation once it's ready for pickup.")
          ]));

          // Clear the text fields and reset dropdown after submission
          nameController.clear();
          ageController.clear();
          selectedGender = null;
          selectedCivilStatus = null;
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

  Widget _buildDropdownField({
    required String hintText,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? selectedItem,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: selectedItem,
          hint: Text(hintText),
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
        'status': 'pending',
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

      final result = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();

      if (result.docs.length > 0) {
        result.docs.forEach((doc) async {
          final notifRef =
              FirebaseFirestore.instance.collection('notifications');

          await notifRef.add({
            'is_read': false,
            'notif_msg': '${fullName} has requested Brgy Clearance.',
            'receiver_uid': doc.id,
            'timestamp': FieldValue.serverTimestamp(),
            'type': 'request',
          });
        });
      }

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
          if (nameController.text.isEmpty ||
              addressController.text.isEmpty ||
              businessStatusController.text.isEmpty ||
              natureOfBusinessController.text.isEmpty ||
              businessLocationController.text.isEmpty ||
              permitNoController.text.isEmpty ||
              amountPaidController.text.isEmpty ||
              validUntilController.text.isEmpty) {
            return;
          }
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

          _addChatMessage(_buildChatBubble([
            Text(
                "Thank you. Your request for a business permit has been submitted. You will receive a confirmation once it's ready for pickup.")
          ]));

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
        'status': 'pending',
        'type': 'Business Permit',
        'date_requested': FieldValue.serverTimestamp(),
        'uid': uid, // Add UID to the Firestore document
        'details': {
          'address': address,
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

      final result = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();

      if (result.docs.length > 0) {
        result.docs.forEach((doc) async {
          final notifRef =
              FirebaseFirestore.instance.collection('notifications');

          await notifRef.add({
            'is_read': false,
            'notif_msg': '${proprietor} has requested Business Permit.',
            'receiver_uid': doc.id,
            'timestamp': FieldValue.serverTimestamp(),
            'type': 'request',
          });
        });
      }

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

  Widget _buildBlotterTextArea(
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
      maxLines: null, // Allows the TextField to grow as needed
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget _buildBarangayIndigencyForm() {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController citizenshipController = TextEditingController();
    TextEditingController civilStatusController = TextEditingController();
    TextEditingController purposeController = TextEditingController();
    String? selectedGender2;
    String? selectedCivilStatus2;

    return _buildChatBubble([
      Text(
        'Please provide the following information for the barangay indigency:',
        style: TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      _buildTextField('Full Name', fullNameController),
      const SizedBox(height: 10),
      _buildTextField('Age', ageController),
      const SizedBox(height: 10),
      _buildTextField('Citizenship', citizenshipController),
      const SizedBox(height: 10),
      _buildDropdownField(
        hintText: 'Select Civil Status',
        items: [
          'Single',
          'Married',
          'Divorced',
          'Widowed',
          'Separated',
          'Annulled'
        ],
        onChanged: (value) {
          selectedCivilStatus2 = value;
        },
      ),
      const SizedBox(height: 10),
      _buildDropdownField(
        hintText: 'Select Gender',
        items: ['Male', 'Female', 'Other'],
        onChanged: (value) {
          selectedGender2 = value;
        },
      ),
      const SizedBox(height: 10),
      _buildTextField('Purpose', purposeController),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          if (fullNameController.text.isEmpty ||
              ageController.text.isEmpty ||
              citizenshipController.text.isEmpty ||
              selectedCivilStatus2 == null ||
              selectedGender2 == null ||
              purposeController.text.isEmpty) {
            return;
          }
          _submitBarangayIndigencyForm(
            fullNameController.text.trim(),
            int.tryParse(ageController.text.trim()) ?? 0,
            citizenshipController.text.trim(),
            selectedCivilStatus2 ??
                '', // Use selectedGender2 instead of genderController
            selectedGender2 ??
                '', // Use selectedGender2 instead of genderController
            purposeController.text.trim(),
          );

          _addChatMessage(_buildChatBubble([
            Text(
                "Thank you. Your request for a barangay indigigency has been submitted. You will receive a confirmation once it's ready for pickup.")
          ]));

          // Clear the text fields after submission
          setState(() {
            fullNameController.clear();
            ageController.clear();
            citizenshipController.clear();
            selectedCivilStatus2 = null;
            purposeController.clear();
            selectedGender2 = null; // Reset gender selection
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

  void _submitBarangayIndigencyForm(
    String fullName,
    int age,
    String citizenship,
    String civilStatus,
    String gender,
    String purpose,
  ) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      // Get the current user's UID
      String? uid = auth.currentUser?.uid;

      await firestore.collection('requests').add({
        'full_name': fullName,
        'status': 'pending',
        'type': 'Barangay Indigency',
        'date_requested': FieldValue.serverTimestamp(),
        'uid': uid, // Add UID to the Firestore document
        'details': {
          'age': age,
          'citizenship': citizenship,
          'civil_status': civilStatus,
          'gender': gender,
          'purpose': purpose,
        },
      });

      final result = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();

      if (result.docs.length > 0) {
        result.docs.forEach((doc) async {
          final notifRef =
              FirebaseFirestore.instance.collection('notifications');

          await notifRef.add({
            'is_read': false,
            'notif_msg': '${fullName} has requested Brgy Indigency.',
            'receiver_uid': doc.id,
            'timestamp': FieldValue.serverTimestamp(),
            'type': 'request',
          });
        });
      }

      // Show confirmation toast message
      Fluttertoast.showToast(
        msg: "Your Barangay Indigency request has been submitted successfully!",
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

  Widget _buildEventPermitForm() {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController citizenshipController = TextEditingController();
    TextEditingController eventNameController = TextEditingController();
    TextEditingController eventPlaceController = TextEditingController();
    TextEditingController eventTimeController = TextEditingController();
    TextEditingController guestNoController = TextEditingController();
    String? selectedGender2;
    String? selectedCivilStatus2;

    final TextEditingController eventDateController = TextEditingController();
    DateTime? selectedDate;

    return _buildChatBubble([
      Text(
        'Please provide the following information for the event permit:',
        style: TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      _buildTextField('Full Name', fullNameController),
      const SizedBox(height: 10),
      _buildTextField('Age', ageController),
      const SizedBox(height: 10),
      _buildTextField('Citizenship', citizenshipController),
      const SizedBox(height: 10),
      _buildDropdownField(
        hintText: 'Select Civil Status',
        items: [
          'Single',
          'Married',
          'Divorced',
          'Widowed',
          'Separated',
          'Annulled'
        ],
        onChanged: (value) {
          selectedCivilStatus2 = value;
        },
      ),
      const SizedBox(height: 10),
      _buildDropdownField(
        hintText: 'Select Gender',
        items: ['Male', 'Female', 'Other'],
        onChanged: (value) {
          selectedGender2 = value;
        },
      ),
      const SizedBox(height: 10),
      _buildTextField('Event Name', eventNameController),
      const SizedBox(height: 10),
      _buildTextField('Event Place', eventPlaceController),
      const SizedBox(height: 10),
      _buildTextField('Event Time', eventTimeController),
      const SizedBox(height: 10),
      _buildTextField(
        'Event Date',
        eventDateController,
        readOnly: true,
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
            eventDateController.text = formattedDate;
            selectedDate = pickedDate;
          }
        },
      ),
      const SizedBox(height: 10),
      _buildTextField('Number of Guests', guestNoController),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          if (fullNameController.text.isEmpty ||
              ageController.text.isEmpty ||
              citizenshipController.text.isEmpty ||
              selectedCivilStatus2 == null ||
              selectedGender2 == null ||
              eventNameController.text.isEmpty ||
              eventPlaceController.text.isEmpty ||
              eventTimeController.text.isEmpty ||
              guestNoController.text.isEmpty ||
              selectedDate == null) {
            return;
          }
          _submitEventPermitForm(
              fullNameController.text.trim(),
              int.tryParse(ageController.text.trim()) ?? 0,
              citizenshipController.text.trim(),
              selectedCivilStatus2 ?? '',
              selectedGender2 ?? '',
              eventNameController.text.trim(),
              eventPlaceController.text.trim(),
              eventTimeController.text.trim(),
              int.tryParse(guestNoController.text.trim()) ?? 0,
              selectedDate ?? DateTime.now());

          // Clear the text fields after submission
          _addChatMessage(_buildChatBubble([
            Text(
                "Thank you. Your request for an event permit has been submitted. You will receive a confirmation once it's ready for pickup.")
          ]));

          setState(() {
            fullNameController.clear();
            ageController.clear();
            citizenshipController.clear();
            selectedCivilStatus2 = null;
            selectedGender2 = null;
            eventNameController.clear();
            eventPlaceController.clear();
            eventTimeController.clear();
            guestNoController.clear();
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

  void _submitEventPermitForm(
      String fullName,
      int age,
      String citizenship,
      String civilStatus,
      String gender,
      String eventName,
      String eventPlace,
      String eventTime,
      int guestNo,
      DateTime eventDate) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      // Get the current user's UID
      String? uid = auth.currentUser?.uid;

      await firestore.collection('requests').add({
        'full_name': fullName,
        'status': 'pending',
        'type': 'Event Permit',
        'date_requested': FieldValue.serverTimestamp(),
        'uid': uid, // Add UID to the Firestore document
        'details': {
          'age': age,
          'citizenship': citizenship,
          'civil_status': civilStatus,
          'gender': gender,
          'event_name': eventName,
          'event_place': eventPlace,
          'event_date': eventDate,
          'event_time': eventTime,
          'guest_no': guestNo,
        },
      });

      final result = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();

      if (result.docs.length > 0) {
        result.docs.forEach((doc) async {
          final notifRef =
              FirebaseFirestore.instance.collection('notifications');

          await notifRef.add({
            'is_read': false,
            'notif_msg': '$fullName has requested an Event Permit.',
            'receiver_uid': doc.id,
            'timestamp': FieldValue.serverTimestamp(),
            'type': 'request',
          });
        });
      }

      // Show confirmation toast message
      Fluttertoast.showToast(
        msg: "Your Event Permit request has been submitted successfully!",
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

  // Household registration form
  Widget _buildHouseholdRegistrationForm() {
    TextEditingController householdHeadController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController numOfMembersController = TextEditingController();
    TextEditingController contactNumberController = TextEditingController();

    List<Map<String, TextEditingController>> membersControllers = [];

    return StatefulBuilder(
      builder: (context, setState) {
        return _buildChatBubble([
          Text(
            'Please provide the following information for Household Registration:',
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildTextField('Household Head', householdHeadController),
          const SizedBox(height: 10),
          _buildTextField('Address', addressController),
          const SizedBox(height: 10),
          _buildTextField('Contact Number', contactNumberController),
          const SizedBox(height: 10),
          _buildTextField('Number of Members', numOfMembersController),
          const SizedBox(height: 10),
          ...membersControllers
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
                      entry.value['name']!,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      'Member Age',
                      entry.value['age']!,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              )
              .toList(),
          ElevatedButton(
            onPressed: () {
              setState(() {
                membersControllers.add({
                  'name': TextEditingController(),
                  'age': TextEditingController(),
                });
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
              List<Map<String, String>> members =
                  membersControllers.map((controllerMap) {
                return {
                  'name': controllerMap['name']!.text.trim(),
                  'age': controllerMap['age']!.text.trim(),
                };
              }).toList();

              if (householdHeadController.text.isEmpty ||
                  addressController.text.isEmpty ||
                  numOfMembersController.text.isEmpty ||
                  contactNumberController.text.isEmpty ||
                  members.isEmpty) {
                return;
              }

              _submitHouseholdRegistrationForm(
                householdHeadController.text.trim(),
                addressController.text.trim(),
                numOfMembersController.text.trim(),
                contactNumberController.text.trim(),
                members,
              );

              _addChatMessage(_buildChatBubble(
                  [Text("Thank you for registering your household details.")]));

              void _clearMembersControllers() {
                for (var controllerMap in membersControllers) {
                  // Dispose of each TextEditingController
                  controllerMap['name']?.clear();
                  controllerMap['age']?.clear();
                }
                // // Clear the list after disposing of the controllers
                // membersControllers.clear();
              }

              // Clear the form fields
              householdHeadController.clear();
              addressController.clear();
              numOfMembersController.clear();
              contactNumberController.clear();
              _clearMembersControllers();
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
        'members': members.map((m) {
          return {'name': m['name'], 'age': int.parse(m['age'] ?? '0')};
        }),
        'user_uid': user?.uid, // Include UID
        'timestamp': FieldValue.serverTimestamp(),
      });

      final result = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();

      if (result.docs.length > 0) {
        result.docs.forEach((doc) async {
          final notifRef =
              FirebaseFirestore.instance.collection('notifications');

          await notifRef.add({
            'is_read': false,
            'notif_msg': '${householdHead} has registered their household.',
            'receiver_uid': doc.id,
            'timestamp': FieldValue.serverTimestamp(),
            'type': 'household',
          });
        });
      }

      // Show success toast
      Fluttertoast.showToast(
        msg: "Your Household Registration has been submitted successfully!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // _addChatMessage(_buildChatBubble([
      //   Text(
      //     'Your Household Registration has been submitted successfully!',
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontSize: 15,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ]));
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
    TextEditingController reportController = TextEditingController();
    TextEditingController complainantController = TextEditingController();
    return _buildChatBubble([
      Text(
        'Please provide the following information for the Blotter Report:',
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10),
      _buildBlotterTextArea(
        'Please describe the incident in detail',
        reportController,
      ),
      const SizedBox(height: 10),
      _buildTextField('Complainant', complainantController),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          if (reportController.text.isEmpty ||
              complainantController.text.isEmpty) {
            return;
          }
          _submitBlotterReportForm(
            reportController.text.trim(),
            complainantController.text.trim(),
          );

          // Clear the form fields
          setState(() {
            reportController.clear();
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
    String complaint,
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
        'complaint': complaint,
        'complainant': complainant,
        'uid': uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      final result = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();

      if (result.docs.length > 0) {
        result.docs.forEach((doc) async {
          final notifRef =
              FirebaseFirestore.instance.collection('notifications');

          await notifRef.add({
            'is_read': false,
            'notif_msg': '${complainant} has submitted a blotter report.',
            'receiver_uid': doc.id,
            'timestamp': FieldValue.serverTimestamp(),
            'type': 'report',
          });
        });
      }

      _addChatMessage(_buildChatBubble([
        Text(
          'Your Blotter Report has been submitted successfully!',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.normal,
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
