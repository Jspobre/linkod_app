import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/drawer.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

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
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.deepOrange,
                      shape: BoxShape.circle,
                    ),
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
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('events')
                      .where('category', isEqualTo: 'events')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No events found.'));
                    }

                    // Print the documents to the console
                    print("Documents: ${snapshot.data!.docs}");

                    return Column(
                      children: snapshot.data!.docs.map((document) {
                        print("Document Data: ${document.data()}");

                        return announcementCard(
                          title: document['title'],
                          date: document['date'].toDate(),
                          time: document['time'],
                          location: document['location'],
                          description: document['description'],
                        );
                      }).toList(),
                    );
                  },
                )
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
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.deepPurple, size: 20),
                SizedBox(width: 8),
                Text(
                  '${date.day}/${date.month}/${date.year}',
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
}
