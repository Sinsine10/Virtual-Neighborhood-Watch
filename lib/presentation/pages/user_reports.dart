import 'package:flutter/material.dart';
import '../../data/services/api_service.dart';
import '../widgets/incident_card.dart';
import '../widgets/add_incident_form.dart';
import '../widgets/EditIncidentDialog.dart';
import '../widgets/menu.dart';

class UserReportsPage extends StatefulWidget {
  const UserReportsPage({super.key});

  @override
  State<UserReportsPage> createState() => _UserReportsPageState();
}

class _UserReportsPageState extends State<UserReportsPage> {
  List<Map<String, dynamic>> _incidents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIncidents();
  }

  Future<void> _loadIncidents() async {
    final incidents = await ApiService().getIncidents();
    setState(() {
      _incidents = incidents;
      _isLoading = false;
    });
  }

  void _addIncident(Map<String, dynamic> newIncident) {
    setState(() {
      _incidents.add(newIncident);
    });
  }

  Future<void> _editIncident(Map<String, dynamic> updatedIncident) async {
    final id = updatedIncident['id'];
    await ApiService().updateIncident(id, updatedIncident);

    final index = _incidents.indexWhere((incident) => incident['id'] == id);
    if (index != -1) {
      setState(() {
        _incidents[index] = updatedIncident;
      });
    }
  }

  Future<void> _deleteIncident(int id) async {
    await ApiService().deleteIncident(id);

    setState(() {
      _incidents.removeWhere((incident) => incident['id'] == id);
    });
  }

  void _showEditDialog(Map<String, dynamic> incident) {
    final titleController = TextEditingController(text: incident['title']);
    final descController = TextEditingController(text: incident['description']);
    final locController = TextEditingController(text: incident['location']);

    showDialog(
      context: context,
      builder: (_) => EditIncidentDialog(
        titleController: titleController,
        descriptionController: descController,
        locationController: locController,
        onSave: () async {
          final updated = {
            'id': incident['id'],
            'title': titleController.text,
            'description': descController.text,
            'location': locController.text,
          };
          await _editIncident(updated);
          Navigator.of(context).pop();
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

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
            Image.asset('assets/lite.png', width: 24, height: 24),
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
              'assets/rectangle.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 230,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _incidents.length,
                    itemBuilder: (context, index) {
                      final incident = _incidents[index];
                      return Column(
                        children: [
                          IncidentCard(
                            title: incident['title'],
                            description: incident['description'],
                            location: incident['location'],
                            onEdit: () => _showEditDialog(incident),
                           onDelete: () async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Incident'),
      content: const Text('Are you sure you want to delete this incident?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Yes'),
        ),
      ],
    ),
  );

  if (shouldDelete == true) {
    await _deleteIncident(incident['id']);
  }
},

                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
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
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AddIncidentForm(
                            onIncidentAdded: (newIncident) async {
                              await ApiService().addIncident(newIncident);
                              _addIncident(newIncident);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Image.asset(
                  'assets/add.png',
                  width: 76,
                  height: 76,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
