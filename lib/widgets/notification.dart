import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/notification_service.dart'; // Import the notification service

class NotificationWidget extends StatefulWidget {
  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  int _unreadCount = 0;
  final NotificationService _notificationService =
      NotificationService(); // Initialize notification service

  @override
  void initState() {
    super.initState();
    _fetchUnreadCount();
    _listenForNewNotifications();
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

    // Optionally, fetch unread count again to update the badge
    _fetchUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
            size: 30.0,
          ),
          onPressed: () {
            _showNotificationDialog(context);
          },
        ),
        if (_unreadCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Center(
                child: Text(
                  '$_unreadCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
      ],
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
                colors: [Colors.deepPurpleAccent, Colors.purple],
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
                    color: Colors.white,
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
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
                              leading: Icon(Icons.notifications,
                                  color: Colors.white),
                              title: Text(
                                notification['notif_msg'] ?? 'No message',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                notification['type'] ?? 'No type',
                                style: TextStyle(color: Colors.grey[200]),
                              ),
                              onTap: () {
                                _markAsRead(notificationId);
                                Navigator.of(context)
                                    .pop(); // Close dialog after clicking
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

  Stream<QuerySnapshot> _getNotificationsStream() {
    final userId =
        FirebaseAuth.instance.currentUser?.uid; // Get the current user's ID
    if (userId == null) {
      return Stream.empty(); // Return an empty stream if no user ID
    }
    return FirebaseFirestore.instance
        .collection('notifications')
        .where('receiver_uid', isEqualTo: userId)
        .snapshots();
  }
}
