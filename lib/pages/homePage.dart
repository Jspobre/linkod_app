import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/drawer.dart';
import '../widgets/chatbot.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  // bool _isChatOpen = false;

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Announcements',
                        style: GoogleFonts.roboto(
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
                      children: <Widget>[
                        categoryChip(0, 'News'),
                        categoryChip(1, 'Events'),
                        categoryChip(2, 'Updates'),
                        categoryChip(3, 'Alerts'),
                        categoryChip(4, 'Notifications'),
                        categoryChip(5, 'Reminders'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Announcement Cards
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: announcementCard(),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: announcementCard(),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: announcementCard(),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: announcementCard(),
                      ),
                      const SizedBox(height: 10),
                    ],
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
      onTap: () {
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
                      style: GoogleFonts.roboto(
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

  // Helper widget to create the announcement card
  Widget announcementCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Increased border radius
      ),
      elevation: 8, // Slightly increased elevation for a more pronounced shadow
      shadowColor: Colors.black.withOpacity(0.2), // Softer shadow color
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFECECEC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.0), // Match border radius
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Logo Image
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    12.0), // Adjusted border radius for image
                child: Image.asset(
                  'images/lingkod_logo.png', // Path to your logo image
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
                      'Exciting Update Available!',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize:
                              20, // Increased font size for better readability
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF312E81),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'We have just released a new update with amazing features. Make sure to check it out!',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.black), // Slightly larger font size
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '20th August 2024, 10:00 AM',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors
                                .grey[600]), // Slightly adjusted grey color
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
