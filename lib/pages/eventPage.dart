import 'package:flutter/material.dart';
import 'package:linkod_app/pages/eventView.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/drawer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Map<String, dynamic>>> _events = {};

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  void _fetchEvents() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('category', isEqualTo: 'Events')
          .get();

      final events = snapshot.docs.map((doc) {
        return {
          'docId': doc.id,
          'title': doc['title'] ?? '',
          'date': (doc['event_date'] as Timestamp?)?.toDate() ?? DateTime.now(),
          'time': doc['event_time'] ?? '',
          'location': doc['event_location'] ?? '',
          'description': doc['description'] ?? '',
          'image': doc['event_pic'] ?? '',
        };
      }).toList();

      Map<DateTime, List<Map<String, dynamic>>> eventMap = {};

      for (var event in events) {
        DateTime eventDate = DateTime.utc(
            (event['date'] as DateTime).year,
            (event['date'] as DateTime).month,
            (event['date'] as DateTime).day,
            (event['date'] as DateTime).hour,
            (event['date'] as DateTime).minute);
        print(eventDate);
        eventMap.putIfAbsent(eventDate, () => []).add(event);
        // eventMap.putIfAbsent(eventDate, () => []).add(event);
      }
      print(eventMap);

      print("Fetched events: $eventMap"); // Debugging statement

      setState(() {
        _events = eventMap;
      });
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 28, 25, 106),
        centerTitle: true,
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
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Container(
            color: Color.fromARGB(255, 28, 25, 106),
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Events',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  eventLoader: (day) {
                    return _events[day] ?? [];
                  },
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (events.isNotEmpty) {
                        // Limit the number of markers to 4 and add a "+x" marker for additional events
                        int markerCount = events.length;
                        List<Widget> markers = events.take(3).map((event) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1.5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueAccent),
                            width: 8.0,
                            height: 8.0,
                          );
                        }).toList();

                        if (markerCount > 3) {
                          markers.add(
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 1.5),
                              child: Text(
                                "+${markerCount - 3}",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 10.0,
                                ),
                              ),
                            ),
                          );
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: markers,
                        );
                      }
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.orange[500],
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                        color: Colors.blueAccent, shape: BoxShape.circle),
                    selectedDecoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    defaultTextStyle: TextStyle(color: Colors.white),
                    weekendTextStyle: TextStyle(color: Colors.red),
                  ),
                  headerStyle: HeaderStyle(
                    titleTextStyle: TextStyle(color: Colors.white),
                    formatButtonTextStyle: TextStyle(color: Colors.white),
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                if (_events[_selectedDay] != null &&
                    _events[_selectedDay]!.isNotEmpty)
                  ..._events[_selectedDay]!.map((event) {
                    return announcementCard(
                        title: event['title'],
                        date: event['date'],
                        time: event['time'],
                        location: event['location'],
                        description: event['description'],
                        imageUrl: event['image'],
                        onRemindMeClicked: () {
                          _addReminder(event['title'], event['date'],
                              event['time'], event['docId']);
                        },
                        docId: event['docId'] ?? '');
                  }).toList()
                else
                  Center(
                      child: Text('No events for this day.',
                          style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget announcementCard({
    required String title,
    required DateTime date,
    required String time,
    required String location,
    required String description,
    required String imageUrl,
    required VoidCallback onRemindMeClicked,
    required String docId,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => EventView(
                  date: date,
                  description: description,
                  imageUrl: imageUrl,
                  location: location,
                  onRemindMeClicked: onRemindMeClicked,
                  time: time,
                  title: title,
                  docId: docId,
                  category: 'Events',
                )));
      },
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
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('reminders')
                          .where('user_id',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.deepPurple, size: 20),
                  SizedBox(width: 8),
                  Text(
                    time,
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
                  Icon(Icons.location_on, color: Colors.deepPurple, size: 20),
                  SizedBox(width: 8),
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
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
                overflow: TextOverflow.ellipsis, // Prevent overflow
                maxLines: 3, // Limit to 3 lines
              ),
              SizedBox(height: 12),
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
    );
  }

  void _addReminder(
      String title, DateTime date, String time, String docId) async {
    try {
      final userId =
          FirebaseAuth.instance.currentUser?.uid; // Get the current user's ID
      await FirebaseFirestore.instance.collection('reminders').add({
        'title': title,
        'date': date,
        'user_id': userId,
        'is_read': false,
        'sent_for_tomorrow': false,
        'sent_for_today': false,
        'time': time,
        'event_doc_id': docId,
      });
      Fluttertoast.showToast(
        msg: "Reminder added for $title",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error adding reminder: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
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
