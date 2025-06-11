import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:neihborhoodwatch/features/tip/presentation/pages/Admin_Tip_screen.dart';
import 'package:neihborhoodwatch/features/tip/presentation/pages/Admin_previous_incident.dart';
import 'package:neihborhoodwatch/features/tip/presentation/pages/Admin_setting_page.dart';
import 'package:neihborhoodwatch/features/tip/presentation/pages/main_Admin_screen.dart';


void main() {
  runApp(
    ProviderScope( // Wrap your app with ProviderScope
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neighbourhood Watch',
      initialRoute: '/',
      routes: {
        '/': (context) => MainAdminScreen(username: ""),
        '/tips': (context) => const AdminTipScreen(),
        '/incidents': (context) => const AdminPreviousIncidentsPage(),
        '/settings': (context) => const AdminSettingsPage(),
      },
    );
  }
}