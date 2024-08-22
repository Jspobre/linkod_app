import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF312E81),
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
        // title: Text('Settings', style: TextStyle(color: Colors.white)),
      ),
      drawer: AppDrawer(),
      backgroundColor: Color(0xFF312E81),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Text
            Center(
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Settings Sections
            Expanded(
              child: ListView(
                children: [
                  settingsSection(
                    title: 'General',
                    options: [
                      settingsOption(
                        icon: Icons.text_fields,
                        title: 'Font Size',
                        onTap: () {
                          // Handle font size option tap
                        },
                      ),
                    ],
                  ),
                  settingsSection(
                    title: 'Security',
                    options: [
                      settingsOption(
                        icon: Icons.security,
                        title: 'Security',
                        onTap: () {
                          // Handle security option tap
                        },
                      ),
                    ],
                  ),
                  settingsSection(
                    title: 'Notifications',
                    options: [
                      settingsOption(
                        icon: Icons.notifications,
                        title: 'Notifications',
                        onTap: () {
                          // Handle notifications option tap
                        },
                      ),
                    ],
                  ),
                  settingsSection(
                    title: 'About',
                    options: [
                      settingsOption(
                        icon: Icons.info,
                        title: 'About',
                        onTap: () {
                          // Handle about option tap
                        },
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

  Widget settingsSection(
      {required String title, required List<Widget> options}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        ...options,
        SizedBox(height: 20),
        Divider(
          color: Colors.white.withOpacity(0.3),
          thickness: 1.0,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget settingsOption(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(vertical: 10),
      tileColor: Color(0xFF4C51BF)
          .withOpacity(0.2), // Slightly different background color for items
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
