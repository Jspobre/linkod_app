import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:intl/intl.dart'; // Import intl package for date formatting
import '../widgets/drawer.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  // Firestore reference
  final CollectionReference blotterReportsCollection =
      FirebaseFirestore.instance.collection('blotter_reports');

  @override
  Widget build(BuildContext context) {
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
                'Report Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Fetch and display Firestore data
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: blotterReportsCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }

                  final reports = snapshot.data?.docs ?? [];

                  if (reports.isEmpty) {
                    return Center(
                      child: Text(
                        'No reports found.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      var reportData =
                          reports[index].data() as Map<String, dynamic>;

                      var report = {
                        'complainant': reportData['complainant'] ?? 'Unknown',
                        'what': reportData['what'] ?? 'Unknown',
                        'where': reportData['where'] ?? 'Unknown',
                        'when': reportData['when'] ?? 'Unknown',
                        'why': reportData['why'] ?? 'Unknown',
                        'how': reportData['how'] ?? 'Unknown',
                        'status': reportData['status'] ?? 'Unknown',
                        'reported_date':
                            reportData['reported_date'] ?? 'Unknown',
                        'reported_time':
                            reportData['reported_time'] ?? 'Unknown',
                        'timestamp':
                            (reportData['timestamp'] as Timestamp?)?.toDate() ??
                                DateTime.now(),
                        'isExpanded': false, // State for expansion
                      };

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            report['isExpanded'] = !report['isExpanded'];
                          });
                        },
                        child: Card(
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            report['complainant'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            report['what'],
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white70),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Reported: ${report['reported_date']}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white70),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Icon(
                                            report['status'] == 'Pending'
                                                ? Icons.pending
                                                : Icons.check_circle,
                                            color: report['status'] == 'Pending'
                                                ? Colors.orange
                                                : Colors.green,
                                            size: 24,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            report['status'],
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: report['status'] ==
                                                        'Pending'
                                                    ? Colors.orange
                                                    : Colors.green),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Expanded section
                                  if (report['isExpanded'])
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Divider(
                                          color: Colors.white38,
                                          thickness: 1,
                                          height: 20,
                                        ),
                                        Text(
                                          'Where: ${report['where']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'When: ${report['when']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Why: ${report['why']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'How: ${report['how']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Reported Time: ${report['reported_time']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Timestamp: ${_formatDate(report['timestamp'])}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
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

  // Helper function to format the date
  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown';
    return DateFormat('MMMM d, yyyy')
        .format(dateTime); // e.g., "August 22, 2024"
  }
}
