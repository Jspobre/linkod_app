import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/drawer.dart';
import '../widgets/chatbot.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<String> _categories = [
    'News',
    'Events',
    'Updates',
    'Alerts',
    'Notifications',
    'Reminders'
  ];

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
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              // Handle notification icon tap
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              color: Color.fromARGB(255, 28, 25, 106),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center horizontally
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Announcements',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Category Slider
                  Container(
                    height: 50.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _categories.asMap().entries.map((entry) {
                        int index = entry.key;
                        String label = entry.value;
                        return categoryChip(index, label);
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Announcement Cards
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('events')
                        .where('category',
                            isEqualTo: _categories[_selectedIndex])
                        .snapshots(),
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
                        return Center(child: CircularProgressIndicator());
                      }

                      final events = snapshot.data?.docs ?? [];

                      if (events.isEmpty) {
                        return Container(
                          color: Color.fromARGB(
                              255, 28, 25, 106), // Retain background color
                          height: MediaQuery.of(context).size.height *
                              0.5, // Set a height to ensure the background color is visible
                          child: Center(
                            child: Text(
                              'No data available',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      return Container(
                        color: Color.fromARGB(255, 28, 25,
                            106), // Ensure background color remains consistent
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.center, // Center horizontally
                          children: events.map((doc) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: announcementCard(doc),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Chatbot Floating Action Button
          ChatBot(),
        ],
      ),
    );
  }

  // Helper widget to create category chips
  Widget categoryChip(int index, String label) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () async {
        // Introduce a delay before changing the selected index
        await Future.delayed(Duration(milliseconds: 200));
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSelected
                  ? [Color(0xFF4C51BF), Color(0xFF6B46C1)]
                  : [Color(0xFF3C3C3C), Color(0xFF3C3C3C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Active category indicator
              if (isSelected)
                Positioned(
                  right: -10,
                  top: -10,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget announcementCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Formatting the date
    DateTime eventDate = data['event_date']?.toDate() ?? DateTime.now();
    String formattedDate = DateFormat('MMMM d, y').format(eventDate);
    String eventTime = data['event_time'] ?? 'No Time';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Logo Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                data['event_pic'] ??
                    'images/placeholder.png', // Fetched event_pic or a placeholder
                height: 80, // Adjust the size of the logo image
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            // Description and Date/Time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'] ?? 'No Title',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF312E81),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    data['description'] ?? 'No Description',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '$formattedDate, $eventTime',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
