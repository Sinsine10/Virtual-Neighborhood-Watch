import 'package:flutter/material.dart';
import '../widgets/settings_button_widget.dart';
import '../widgets/menu.dart';
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
            Image.asset('assets/Settings.png', width: 24, height: 24),
            const SizedBox(width: 10),
            const Text(
              'Settings',
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
          /// ✅ Replace curved background with bottom image
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              'assets/rectangle.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 230,
            ),
          ),

          /// ✅ Buttons stay centered
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0 , vertical: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SettingsButtonWidget(
                    icon: Icons.logout,
                    label: 'Logout',
                    onTap: () {
                      // Handle logout
                    },
                  ),
                  SettingsButtonWidget(
                    icon: Icons.delete,
                    label: 'Delete Account',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Account'),
                          content: const Text(
                            'Are you sure you want to delete your account? This action cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Perform delete logic
                                Navigator.pop(context);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
