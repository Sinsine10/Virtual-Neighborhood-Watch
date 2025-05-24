import 'package:flutter/material.dart';

class IncidentCardWidget extends StatelessWidget {
  final int number;
  final String title;
  final String description;
  final String location;

  const IncidentCardWidget({
    super.key,
    required this.number,
    required this.title,
    required this.description,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Incident $number',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text('Title: $title', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Description: $description'),
            const SizedBox(height: 6),
            Text('Location: $location'),
          ],
        ),
      ),
    );
  }
}
