import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import '../widgets/drawer.dart';

class ElectricBillPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 25, 106),
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
      backgroundColor: const Color.fromARGB(255, 28, 25, 106),
      body: FutureBuilder<DocumentSnapshot>(
        future: _getUserBill(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No bill data available'));
          }

          var billData = snapshot.data!.data() as Map<String, dynamic>;
          return _buildBillCard(
              context, billData); // Pass context to the buildBillCard method
        },
      ),
    );
  }

  Future<DocumentSnapshot> _getUserBill() async {
    User? currentUser = _auth.currentUser;
    return await _firestore
        .collection('bills')
        .where('uid', isEqualTo: currentUser?.uid)
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs.first);
  }

  String _formatDate(Timestamp timestamp) {
    return DateFormat('MMMM d, yyyy').format(timestamp.toDate());
  }

  Widget _buildBillCard(BuildContext context, Map<String, dynamic> billData) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text(
                'Electric Bill Notice',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.9, // Adjust width to avoid overflow
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4A4A9F), Color(0xFF6A6AD9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Colors.white,
                            size: 40,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'BAPA CONSUMPTION FORM',
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow('BAPA Member Name', billData['bapa_name']),
                    const SizedBox(height: 10),
                    _buildInfoRow('Meter No.', billData['meter_no'].toString()),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Month/Year',
                      _formatDate(billData['month'] as Timestamp),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Total Amount',
                      '₱ ${billData['total_due']}',
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Date Released',
                      _formatDate(billData['date_released'] as Timestamp),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Due Date',
                      _formatDate(billData['due_date'] as Timestamp),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Disconnection Date',
                      _formatDate(billData['disconnection_date'] as Timestamp),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end, // Ensure text aligns correctly
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
