import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neihborhoodwatch/features/auth/presentation/providers/usecase_provider.dart';
import 'features/auth/presentation/pages/home_screen.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/register_screen.dart';
import 'features/incident/presentation/pages/incident_screen.dart';
import 'features/incident/presentation/pages/main_user_screen.dart';
import 'features/tip/presentation/pages/Admin_Tip_screen.dart';
import 'features/tip/presentation/pages/Admin_previous_incident.dart';
import 'features/tip/presentation/pages/Admin_setting_page.dart';
import 'features/tip/presentation/pages/main_Admin_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neighbourhood Watch',
      debugShowCheckedModeBanner: false,
      home: NeighbourhoodWatchApp(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register':(context)=> const RegisterScreen(),
        '/admin': (context) => MainAdminScreen(username: 'Admin'), // use '/admin'

        '/user': (context) => const MainUserScreen(),
        '/tips': (context) => const AdminTipScreen(),
        '/incidents': (context) => const AdminPreviousIncidentsPage(),
        '/settings': (context) => const AdminSettingsPage(),
        '/UserReportsPage': (context) => const UserReportsPage(),

      },
    );
  }
}
