import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../incident/presentation/pages/previous_incident.dart';
import '../../../incident/presentation/widgets/AppBar_Widger.dart';
import '../../../incident/presentation/widgets/previous_incident_card.dart';
import '../widgets/navigation_Widger.dart';

import '../../../incident/presentation/providers/incident_provider.dart'; // adjust the import path

class AdminPreviousIncidentsPage extends ConsumerStatefulWidget {
  const AdminPreviousIncidentsPage({super.key});

  @override
  ConsumerState<AdminPreviousIncidentsPage> createState() => _AdminPreviousIncidentsPageState();
}

class _AdminPreviousIncidentsPageState extends ConsumerState<AdminPreviousIncidentsPage> {
  String? selectedLocation;
  final List<String> locations = ['6 kilo', '5 kilo', '4 kilo', 'sefereselam', 'lideta'];

  @override
  Widget build(BuildContext context) {
    // Now you can use ref inside build
    final incidents = ref.watch(incidentNotifierProvider);

    // Filter incidents by location if selected
    final filteredIncidents = selectedLocation == null
        ? incidents
        : incidents.where((incident) => incident.location == selectedLocation).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFD07C7C),
      endDrawer: const AppNavigationDrawer(),
      appBar: AppBarWidget(
        customImage: 'assets/privconicon.png',
        text: 'Previous Incidents',
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDropdown(),
                const SizedBox(height: 24),

                // Here is the key change:
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5, // 50% of screen height
                  child: incidents.isEmpty
                      ? const Center(child: Text("No incidents found."))
                      : ListView.builder(
                    itemCount: filteredIncidents.length,
                    itemBuilder: (context, index) {
                      final incident = filteredIncidents[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: IncidentCardWidget(
                          number: index + 1,
                          title: incident.title,
                          description: incident.description,
                          location: incident.location,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        hint: const Text('Choose your location', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        value: selectedLocation,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.brown),
        underline: const SizedBox(),
        onChanged: (value) {
          setState(() {
            selectedLocation = value;
          });
        },
        items: locations.map((String location) {
          return DropdownMenuItem<String>(
            value: location,
            child: Text(location, style: const TextStyle(color: Colors.black)),
          );
        }).toList(),
      ),
    );
  }
}
