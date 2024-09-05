import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/drawer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest_utc.dart' as tz;

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
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.deepOrange,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 0, 0),
                        shape: BoxShape.circle),
                    selectedDecoration: BoxDecoration(
                      color: Colors.blueAccent,
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
                    );
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
  }) {
    return Card(
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
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF312E81),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedDay = date;
                      _focusedDay = date;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Remind Me',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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
                Icon(Icons.calendar_today, color: Colors.deepPurple, size: 20),
                SizedBox(width: 8),
                Text(
                  '${_formatDate(date)}',
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
