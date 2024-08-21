import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class RequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF312E81), // Background color
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
      backgroundColor: Color(0xFF312E81),
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
            // Card for Document Request
            Card(
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
                      // Request Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Document Request',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'File: Baranggay Clearance',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.white70),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Status:',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white70),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.pending, // Pending Icon
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Pending',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.orange),
                                ),
                              ],
                            ),
                            // If you want to show a successful status, replace the above with:
                            /*
                            Row(
                              children: [
                                Text(
                                  'Status:',
                                  style: TextStyle(fontSize: 14, color: Colors.white70),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.check_circle, // Success Icon
                                  color: Colors.green,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Success',
                                  style: TextStyle(fontSize: 14, color: Colors.green),
                                ),
                              ],
                            ),
                            */
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
