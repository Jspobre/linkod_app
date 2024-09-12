import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:linkod_app/pages/electricBillPage.dart';
import 'package:linkod_app/pages/eventPage.dart';
import 'package:linkod_app/pages/reportPage.dart';
import 'package:linkod_app/pages/requestPage.dart';
import '../service/notification_service.dart'; // Import the notification service
import 'package:badges/badges.dart' as badges;

class NotificationWidget extends StatefulWidget {
  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  int _unreadCount = 0;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    // _fetchUnreadCount();
    // _listenForNewNotifications();
    _checkReminders();
  }

  void _fetchUnreadCount() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('receiver_uid', isEqualTo: userId)
        .where('is_read', isEqualTo: false)
        .get();

    setState(() {
      _unreadCount = snapshot.docs.length;
    });
  }

  void _listenForNewNotifications() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    FirebaseFirestore.instance
        .collection('notifications')
        .where('receiver_uid', isEqualTo: userId)
        .where('is_read', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final message = data['notif_msg'] ?? 'No message';
        final type = data['type'] ?? 'No type';
        _notificationService.showNotification(type, message);
      }
    });
  }

  void _markAsRead(String notificationId) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId)
        .update({'is_read': true});
    // _fetchUnreadCount();
  }

  void _checkReminders() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day, 12, 00, 00);
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final startOfTomorrow = startOfToday.add(Duration(days: 1));
    final endOfTomorrow = endOfToday.add(Duration(days: 1));

    // Fetch reminders from today to the end of tomorrow
    final reminderSnapshot = await FirebaseFirestore.instance
        .collection('reminders')
        .where('user_id', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfToday))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfTomorrow))
        .get();

    for (var doc in reminderSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final title = data['title'] ?? 'No title';
      final date = (data['date'] as Timestamp).toDate();
      final time = data['time'] ?? '';

      // Check if the event is for tomorrow
      if (date.isAfter(endOfToday) && date.isBefore(endOfTomorrow)) {
        // Send local notification for tomorrow's event
        _notificationService.showNotification(
          'Reminder: $title',
          'The event is tomorrow at $time!',
        );
      }

      // Check if the event is for today
      if (date.isAfter(now) && date.isBefore(endOfToday) ||
          date.isAtSameMomentAs(now)) {
        // Send local notification for today's event
        _notificationService.showNotification(
          'Reminder: $title',
          'Today at $time!',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: FirebaseAuth.instance.currentUser?.uid != null
          ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .where('receiver_uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .where('is_read', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                print(FirebaseAuth.instance.currentUser?.uid);
                int messageCount = snapshot.data?.docs.length ?? 0;
                print(messageCount);

                return badges.Badge(
                  showBadge: messageCount > 0,
                  badgeContent: Text(
                    messageCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 30.0,
                  ),
                );
              })
          : Icon(
              Icons.notifications,
              color: Colors.white,
              size: 30.0,
            ),
      onPressed: () {
        _showNotificationDialog(context);
      },
    );
  }

  void _showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 16,
          child: Container(
            padding: EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 234, 234, 235)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _getNotificationsStream(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            'No notifications available.',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        );
                      }

                      final notifications = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (BuildContext context, int index) {
                          final notification = notifications[index].data()
                              as Map<String, dynamic>;
                          final notificationId = notifications[index].id;
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurple.shade300,
                                  Colors.deepPurple.shade600,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: notification['type'] == 'request'
                                  ? Icon(Icons.mail, color: Colors.white)
                                  : notification['type'] == 'report'
                                      ? Icon(Icons.file_open)
                                      : notification['type'] == 'event'
                                          ? Icon(Icons.event)
                                          : notification['type'] == 'bill'
                                              ? Icon(Icons.electric_bolt)
                                              : Icon(Icons.notifications,
                                                  color: Colors.white),
                              title: Text(
                                notification['notif_msg'] ?? 'No message',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                formatDateTime(notification['timestamp']),
                                style: TextStyle(
                                    color: Colors.grey[200],
                                    fontSize: 10,
                                    fontStyle: FontStyle.italic),
                              ),
                              onTap: () {
                                _markAsRead(notificationId);
                                if (notification['type'] == 'request') {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RequestPage()));
                                } else if (notification['type'] == 'report') {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ReportPage()));
                                } else if (notification['type'] == 'event') {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          EventsPage()));
                                } else if (notification['type' == 'bill']) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ElectricBillPage()));
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text('Close', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatDateTime(Timestamp dateTime) {
    DateTime notifDateTime = dateTime.toDate();
    DateTime now = DateTime.now();

    DateTime dateToday = DateTime(now.year, now.month, now.day);
    DateTime notifDate =
        DateTime(notifDateTime.year, notifDateTime.month, notifDateTime.day);

    bool isSameDate = dateToday.isAtSameMomentAs(notifDate);

    String formattedDateTime = (isSameDate)
        ? DateFormat('hh:mm a').format(notifDateTime)
        : (notifDateTime.isAfter(
            now.subtract(const Duration(days: 6)),
          ))
            ? DateFormat('EEE \'at\' hh:mm a').format(notifDateTime)
            : (notifDateTime.isAfter(
                DateTime(now.year - 1, now.month, now.day),
              ))
                ? DateFormat('MMM d \'at\' hh:mm a').format(notifDateTime)
                : DateFormat('MM/dd/yy \'at\' hh:mm a').format(notifDateTime);

    return formattedDateTime;
  }

  Stream<QuerySnapshot> _getNotificationsStream() {
    final userId =
        FirebaseAuth.instance.currentUser?.uid; // Get the current user's ID
    if (userId == null) {
      return Stream.empty(); // Return an empty stream if no user ID
    }
    return FirebaseFirestore.instance
        .collection('notifications')
        .where('receiver_uid', isEqualTo: userId)
        .where('is_read', isEqualTo: false)
        .snapshots();
  }
}
