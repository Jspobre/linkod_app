// announcement_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String description;
  final String dateTime;
  final String imagePath;
  final bool isSuccess; // Optional parameter to handle different statuses

  AnnouncementCard({
    required this.title,
    required this.description,
    required this.dateTime,
    required this.imagePath,
    this.isSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
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
              child: Image.asset(
                imagePath,
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
                    title,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF312E81),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    dateTime,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        isSuccess ? Icons.check_circle : Icons.pending,
                        color: isSuccess ? Colors.green : Colors.orange,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        isSuccess ? 'Success' : 'Pending',
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: isSuccess ? Colors.green : Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
