import 'package:flutter/material.dart';
import 'package:neihborhoodwatch/features/incident/domain/entities/incident.dart';

class AddIncidentForm extends StatefulWidget {
  final Function(Incident) onIncidentAdded;

  const AddIncidentForm({super.key, required this.onIncidentAdded});

  @override
  State<AddIncidentForm> createState() => _AddIncidentFormState();
}

class _AddIncidentFormState extends State<AddIncidentForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedLocation;

  final List<String> _locations = [
    '6 kilo',
    '5 kilo',
    '4 kilo',
    'sefereselam',
    'lideta',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 32,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(label: 'Title', controller: _titleController),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Description',
                controller: _descriptionController,
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              _buildDropdown(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF794747),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                child: const Text(
                  'submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF794747),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLocation,
          isExpanded: true,
          dropdownColor: Colors.white,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          hint: const Text(
            'Choose your location',
            style: TextStyle(color: Colors.white),
          ),
          items: _locations.map((location) {
            return DropdownMenuItem<String>(
              value: location,
              child: Text(location),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedLocation = value;
            });
          },
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        ),
      ),
    );
  }

  void _submitForm() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final location = _selectedLocation;

    if (title.isEmpty || description.isEmpty || location == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final newIncident = Incident(
      id: '', // empty or generate id if needed, backend usually assigns id
      title: title,
      description: description,
      location: location,
    );

    widget.onIncidentAdded(newIncident);
    Navigator.pop(context);
  }
}
