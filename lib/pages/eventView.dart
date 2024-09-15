import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventView extends StatelessWidget {
  final String title;
  final DateTime date;
  final String? time;
  final String? location;
  final String description;
  final String imageUrl;
  final VoidCallback onRemindMeClicked;
  final String docId;
  final String category;

  const EventView(
      {super.key,
      required this.date,
      required this.description,
      required this.imageUrl,
      this.location,
      required this.onRemindMeClicked,
      this.time,
      required this.title,
      required this.docId,
      required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 28, 25, 106),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF312E81),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(width: 10),
                      if (FirebaseAuth.instance.currentUser?.uid != null &&
                          category == 'Events')
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('reminders')
                                .where('user_id',
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser!.uid)
                                .where('event_doc_id', isEqualTo: docId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data!.docs.length > 0) {
                                return SizedBox.shrink();
                              }
                              return ElevatedButton(
                                onPressed: () {
                                  onRemindMeClicked();
                                  Fluttertoast.showToast(
                                    msg: "Reminder set for $title",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Remind Me',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }),
                    ],
                  ),
                  SizedBox(height: 12),
                  if (imageUrl.isNotEmpty)
                    Image.network(
                      imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: Colors.deepPurple, size: 20),
                      SizedBox(width: 8),
                      Text(
                        _formatDate(date),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  if (category == 'Events')
                    Column(
                      children: [
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                color: Colors.deepPurple, size: 20),
                            SizedBox(width: 8),
                            Text(
                              time ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Colors.deepPurple, size: 20),
                            SizedBox(width: 8),
                            Text(
                              location ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  if (category == 'Events') SizedBox(height: 12),
                  if (category == 'Events')
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '#fun #seeyou',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  String _formatDate(DateTime date) {
    // Format date as "August 22, 2024"
    return "${_monthName(date.month)} ${date.day}, ${date.year}";
  }

  String _monthName(int month) {
    // Return month name based on month number
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
        return "Unknown";
    }
  }
}
