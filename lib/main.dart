import 'package:flutter/material.dart';
import 'package:neihborhoodwatch/presentation/pages/Admin_Tip_screen.dart';
import 'package:neihborhoodwatch/presentation/pages/Admin_previous_incident.dart';
import 'package:neihborhoodwatch/presentation/pages/Admin_setting_page.dart';
import 'package:neihborhoodwatch/viewmodels/incident_viewmodel.dart';
import 'package:neihborhoodwatch/viewmodels/tip_viewmodel.dart';
import 'package:provider/provider.dart';
import 'presentation/pages/main_Admin_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TipViewModel()),
        ChangeNotifierProvider(create: (_) => IncidentViewModel()),
      ],
      child: MaterialApp(
        title: 'Neighbourhood Watch',
        initialRoute: '/',
        routes: {
          '/': (context) =>  MainAdminScreen(username: 'Hayat'),
          '/tips': (context) => const AdminTipScreen(),
          '/incidents': (context) => const AdminPreviousIncidentsPage(),
          '/settings': (context) => const AdminSettingsPage(),
        },
      ),
    );
  }
}