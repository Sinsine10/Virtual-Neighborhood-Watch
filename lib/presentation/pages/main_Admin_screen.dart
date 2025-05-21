import 'package:flutter/material.dart';

import 'Admin_Tip_screen.dart';
import 'Admin_previous_incident.dart';
import 'Admin_setting_page.dart';

class MainAdminScreen extends StatelessWidget {
  final String username;

  MainAdminScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFCA7F7F), // light pink color for full screen
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(height: 48), // Increased spacing to lower header
                  // Header Row
                  Row(
                    children: [
                      Image.asset('assets/headericon.png', width: 67, height: 67),
                      SizedBox(width: 16),
                      Text(
                        'Neighbourhood Watch',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Welcome Back, User',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 64),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Tips Section
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminTipScreen(),
                                ),
                              );
                            },
                            child: Image.asset('assets/vector.png', width: 81, height: 81),
                          ),
                          SizedBox(height: 10),
                          Text('Tips', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      // Previous Incidents Section
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminPreviousIncidentsPage(),
                                ),
                              );
                            },
                            child: Image.asset('assets/group_5.png', width: 88, height: 88),
                          ),
                          SizedBox(height: 5),
                          Text('Previous Incidents', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Settings Section
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminSettingsPage(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 40.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('assets/group_9.png', width: 88, height: 88),
                            SizedBox(height: 5),
                            Text('Settings', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom image positioned at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset('assets/bottom.png', fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}