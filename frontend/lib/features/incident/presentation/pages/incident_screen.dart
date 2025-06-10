import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neihborhoodwatch/features/incident/domain/entities/incident.dart';
import '../widgets/EditIncidentDialog.dart';
import '../widgets/incident_card.dart';
import '../widgets/add_incident_form.dart';
import '../widgets/menu.dart';
import '../providers/incident_provider.dart';

class UserReportsPage extends ConsumerWidget {
  const UserReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incidents = ref.watch(incidentNotifierProvider);
    final notifier = ref.read(incidentNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFD07C7C),
      endDrawer: const AppMenuDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF794747),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/reporticon.png', width: 24, height: 24),
            const SizedBox(width: 10),
            const Text('Report Incidents', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Image.asset('assets/menu.png', width: 24, height: 24, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
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
              height: 230,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: incidents.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
              height: 500,  // reduced height for ListView
              child: ListView.builder(
                itemCount: incidents.length,
                itemBuilder: (context, index) {
                  final incident = incidents[index];
                  return Column(
                    children: [
                      IncidentCard(
                        title: incident.title,
                        description: incident.description,
                        location: incident.location,
                        onEdit: () => _showEditDialog(context, notifier, incident),
                        onDelete: () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Incident'),
                              content: const Text('Are you sure you want to delete this incident?'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('No')),
                                TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Yes')),
                              ],
                            ),
                          );

                          if (shouldDelete == true) {
                            await notifier.deleteIncident(incident.id as String);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 30.0, bottom: 60.0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AddIncidentForm(
                          onIncidentAdded: (newIncident) async {
                            try {
                              await notifier.addIncident(newIncident as Incident);
                              Navigator.of(context).pop(); // Close dialog on success
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to add incident: $e')),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
                child: Image.asset('assets/add.png', width: 76, height: 76),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, IncidentNotifier notifier, Incident incident) {
    final titleController = TextEditingController(text: incident.title);
    final descController = TextEditingController(text: incident.description);
    final locController = TextEditingController(text: incident.location ?? "");

    showDialog(
      context: context,
      builder: (_) => EditIncidentDialog(
        titleController: titleController,
        descriptionController: descController,
        locationController: locController,
        onSave: () async {
          await notifier.updateIncident(
            incident.copyWith(
              title: titleController.text,
              description: descController.text,
              location: locController.text,
            ),
          );
          Navigator.pop(context);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }
}
