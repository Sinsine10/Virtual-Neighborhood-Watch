import 'package:flutter/material.dart';
import '../widgets/home_button_widget.dart';
import 'previous_incident.dart';
import 'tips_page.dart'; // adjust path if needed
import 'emergency_contact_page.dart';
import 'settings_page.dart';
import 'incident_screen.dart';
class MainUserScreen extends StatelessWidget {
  const MainUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFD07C7C),
      body: SafeArea(
        child: Stack(
          children: [
            // Bottom Background Image
            Align(
              alignment: Alignment.bottomLeft,
              child: Image.asset(
                'assets/bottom.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 230,
              ),
            ),


            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo & Title
                 Row(
  children: [
    Image.asset(
      'assets/logo.png', // Replace with your actual icon image
      width: 70,
      height: 70,
    ),
    const SizedBox(width: 10),
    const Text(
      'Neighbourhood Watch',
      style: TextStyle(
        fontSize: 18,
       color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
),

                  const SizedBox(height: 30),
                  const Center(
  child: Text(
    'Welcome Back Username',
    style: TextStyle(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
  ),
),
                  const SizedBox(height: 20),

                  // Grid Buttons with Images
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                       padding: EdgeInsets.all(8),
                      children: [
  HomeButtonWidget(
    imagePath: 'assets/report.png',
    label: 'Report Incidents',
    onTap: () {
      Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const UserReportsPage(),
  ),
);

    },
  ),

                       HomeButtonWidget(
  imagePath: 'assets/group_5.png',
  label: 'Previous Incidents',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PreviousIncidentsPage(),
      ),
    );
  },
),

                        HomeButtonWidget(
  imagePath: 'assets/light.png',
  label: 'Tips',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TipsPage()),
    );
  },
),


                        HomeButtonWidget(
  imagePath: 'assets/phone.png',
  label: 'Emergency Contact',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmergencyContactPage()),
    );
  },
),


                        HomeButtonWidget(
  imagePath: 'assets/setting.png',
  label: 'Settings',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  },
),


                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
