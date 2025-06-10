import 'package:flutter/material.dart';
import '../pages/incident_screen.dart';

import '../pages/previous_incident.dart';
import '../pages/tips_page.dart';
import '../pages/emergency_contact_page.dart';
import '../pages/settings_page.dart';

class AppMenuDrawer extends StatelessWidget {
  const AppMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16),
        children: [
          ListTile(
            title: const Text('Report Incidents'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserReportsPage(),),
              );
            },
          ),
          ListTile(
            title: const Text('Previous Incidents'),
            onTap: () {
              Navigator.pop(context);
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (_) => const PreviousIncidentsPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Tips'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TipsPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Emergency Contact'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EmergencyContactPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
