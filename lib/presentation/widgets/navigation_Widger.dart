import 'package:flutter/material.dart';
import '../pages/Admin_previous_incident.dart';
import '../pages/Admin_Tip_screen.dart';
import '../pages/Admin_setting_page.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
        children: [
          ListTile(
            title: const Text(
              'Tips',
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 18.0,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>  AdminTipScreen()),
              );
            },
          ),
          ListTile(
            title: const Text(
              'Previous Incidents',
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 16.0,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminPreviousIncidentsPage()),
              );
            },
          ),

          ListTile(
            title: const Text(
              'Settings',
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 16.0,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminSettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}