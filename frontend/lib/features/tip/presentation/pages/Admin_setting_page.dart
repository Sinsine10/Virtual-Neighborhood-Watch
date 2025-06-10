import 'package:flutter/material.dart';
import '../../../auth/presentation/pages/home_screen.dart';
import '../widgets/Admin_settings_button_widget.dart';
import '../widgets/AppBar_Widger.dart';
import '../widgets/navigation_Widger.dart'; // Assuming this is where NavigationDrawer is defined

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD07C7C),
      endDrawer: const AppNavigationDrawer(), // Changed from AppMenuDrawer to NavigationDrawer
      appBar: AppBarWidget(
        customImage: 'assets/settingsicon.png',
        text: 'Settings',
        onCustomImageClick: () {
          print('Custom image clicked');
        },
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              'assets/bottom.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 230,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading rectangle.png: $error');
                return const SizedBox.shrink();
              },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SettingsButtonWidget(
                    icon: Icons.logout,
                    label: 'Logout',
                onTap: () {
                  // TODO: Add your logout logic here, like clearing auth tokens/session

                  // Navigate back to NeighbourhoodWatchApp and remove all previous routes
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const NeighbourhoodWatchApp()),
                        (route) => false,
                  );
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
                                // TODO: Add your logout logic here, like clearing auth tokens/session

                                // Navigate back to NeighbourhoodWatchApp and remove all previous routes
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const NeighbourhoodWatchApp()),
                                      (route) => false,
                                );
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