import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import '../widgets/drawer.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user's UID
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 28, 25, 106), // Background color
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
      backgroundColor: Color.fromARGB(255, 28, 25, 106),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Text
            Center(
              child: Text(
                'Request/Report Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            // StreamBuilder to fetch and display request details
            Expanded(
              // Use Expanded to make the ListView take the remaining space
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('blotter_reports')
                    .where('uid', isEqualTo: uid) // Filter by UID
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No reports found.'));
                  }

                  // Display each request in a ListView.builder
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var document = snapshot.data!.docs[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 8,
                        shadowColor: Colors.black.withOpacity(0.3),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF4C51BF), Color(0xFF6B46C1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // Custom Icon (can replace with a logo or another icon)
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.description,
                                    color: Color(0xFF312E81),
                                    size: 30,
                                  ),
                                ),
                                SizedBox(width: 16),
                                // Report Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Blotter Report',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Complainant: ${document['complainant'] ?? 'Unknown'}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'What: ${document['what'] ?? 'Unknown'}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Where: ${document['where'] ?? 'Unknown'}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'When: ${document['when'] ?? 'Unknown'}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Why: ${document['why'] ?? 'Unknown'}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'How: ${document['how'] ?? 'Unknown'}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            'Status:',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white70),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            document['status'] == 'Pending'
                                                ? Icons.pending
                                                : Icons.check_circle,
                                            color:
                                                document['status'] == 'Pending'
                                                    ? Colors.orange
                                                    : Colors.green,
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            document['status'] ?? 'Unknown',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: document['status'] ==
                                                        'Pending'
                                                    ? Colors.orange
                                                    : Colors.green),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Reported Date: ${document['reported_date'] ?? 'Unknown'}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Reported Time: ${document['reported_time'] ?? 'Unknown'}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Timestamp: ${_formatDate(document['timestamp'])}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to format the date from a Timestamp
  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';
    DateTime date = timestamp.toDate();
    return DateFormat('MMMM d, yyyy').format(date); // e.g., "August 22, 2024"
  }
}
