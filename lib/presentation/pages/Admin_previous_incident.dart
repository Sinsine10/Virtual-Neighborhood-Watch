import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/incident_viewmodel.dart';
import '../widgets/Admin_privious_incident_card.dart';
import '../widgets/AppBar_Widger.dart';
import '../widgets/navigation_Widger.dart';

class AdminPreviousIncidentsPage extends StatefulWidget {
  const AdminPreviousIncidentsPage({super.key});

  @override
  State<AdminPreviousIncidentsPage> createState() => _PreviousIncidentsPageState();
}

class _PreviousIncidentsPageState extends State<AdminPreviousIncidentsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IncidentViewModel>().fetchIncidents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea( // Ensures content respects status bar and notches
      child: Consumer<IncidentViewModel>(
        builder: (context, viewModel, child) {
          // Calculate available height with a buffer
          final double screenHeight = MediaQuery.of(context).size.height;
          final double appBarHeight = kToolbarHeight; // Default AppBar height
          final double bottomImageHeight = 230;
          final double paddingTotal = 32; // 16 (top) + 16 (bottom)
          final double dropdownSpacing = 30;
          final double buffer = 45; // Additional buffer to reduce height further

          final double maxListHeight = screenHeight -
              appBarHeight -
              bottomImageHeight -
              paddingTotal -
              dropdownSpacing -
              buffer;

          return Scaffold(
            backgroundColor: const Color(0xFFD07C7C),
            endDrawer: const AppNavigationDrawer(),
            appBar: AppBarWidget(
              customImage: 'assets/priviconicon.png',
              text: 'Previous Incidents',
              onCustomImageClick: () {
                print('Custom image clicked');
              },
            ),
            body: Stack(
              children: [
                // Bottom image with fixed height
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    'assets/bottom.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 230,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading bottom.png: $error');
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildDropdown(viewModel),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: maxListHeight, // Explicit height constraint
                        child: viewModel.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : viewModel.errorMessage != null
                            ? Center(child: Text(viewModel.errorMessage!))
                            : ListView.builder(
                          itemCount: viewModel.incidents.length,
                          itemBuilder: (context, index) {
                            final incident = viewModel.incidents[index];
                            return IncidentCardWidget(
                              number: index + 1,
                              title: incident.title,
                              description: incident.description,
                              location: incident.location,
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
        },
      ),
    );
  }

  Widget _buildDropdown(IncidentViewModel viewModel) {
    final locations = viewModel.getLocations();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        hint: const Text(
          'Choose your location',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        value: viewModel.selectedLocation,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.brown),
        underline: const SizedBox(),
        onChanged: (value) {
          viewModel.setSelectedLocation(value);
        },
        items: locations.map((String location) {
          return DropdownMenuItem<String>(
            value: location,
            child: Text(
              location,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }
}