import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkod_app/pages/loginPage.dart'; // Update with your login page import
import '../pages/homePage.dart';
import '../pages/profilePage.dart';
import '../pages/eventPage.dart';
import '../pages/requestReportPage.dart';
import '../pages/settingsPage.dart';
import '../pages/electricBillPage.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 28, 25, 106),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/lingkod_logo.png', // Path to your logo
                  height: 100, // Adjust the size of the logo
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.black, size: 30.0),
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.black, size: 30.0),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.event, color: Colors.black, size: 30.0),
            title: Text('Events'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.report, color: Colors.black, size: 30.0),
            title: Text('Report/Request Status'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RequestPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.report, color: Colors.black, size: 30.0),
            title: Text('Electric Bill Notice'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ElectricBillPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.black, size: 30.0),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.black, size: 30.0),
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
