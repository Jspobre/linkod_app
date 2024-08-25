import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 25, 106),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
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
      backgroundColor: const Color.fromARGB(255, 28, 25, 106),
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
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
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
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A4A9F), Color(0xFF6A6AD9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ...options,
        const SizedBox(height: 20),
        Divider(
          color: Colors.white.withOpacity(0.3),
          thickness: 1.0,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget settingsOption(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF4A4A9F), Color(0xFF6A6AD9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      tileColor: const Color(0xFF4C51BF).withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
