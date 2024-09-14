import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:linkod_app/widgets/reportCard.dart';
import '../widgets/drawer.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  // Firestore reference
  final CollectionReference blotterReportsCollection =
      FirebaseFirestore.instance.collection('blotter_reports');

  // Map to keep track of expanded states
  Map<String, bool> expandedStates = {};

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
                      var reportId = reports[index].id;

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
                        'isExpanded': expandedStates[reportId] ??
                            false, // Get the expansion state from the map
                      };

                      return ReportCard(report: report);
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
}
