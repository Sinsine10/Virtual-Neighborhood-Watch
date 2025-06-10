import 'package:flutter/material.dart';
import '../widgets/emergency_contact_card.dart';
import '../widgets/menu.dart';
class EmergencyContactPage extends StatelessWidget {
  const EmergencyContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD07C7C),

       endDrawer: const AppMenuDrawer(),

      appBar: AppBar(
        backgroundColor: const Color(0xFF794747),
        elevation: 0,
         automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/phoneicon.png', width: 24, height: 24),
            const SizedBox(width: 8),
            const Text(
              'Emergency Contact',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Image.asset(
                'assets/menu.png',
                width: 24,
                height: 24,
                color: Colors.white,
              ),
              onPressed: () {
                
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              'assets/bottom.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
          ),
          ListView(
            padding: const EdgeInsets.all(20),
            children: const [
              EmergencyContactCard(
                iconPath: 'assets/ambulance.png',
                label: 'Ambulance - 911',
              ),
              SizedBox(height: 16),
              EmergencyContactCard(
                iconPath: 'assets/fire.png',
                label: 'Fire Department - 911',
              ),
              SizedBox(height: 16),
              EmergencyContactCard(
                iconPath: 'assets/police.png',
                label: 'Police - 911',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
