// lib/features/incident/data/models/incident_model.dart

import 'package:neihborhoodwatch/features/incident/domain/entities/incident.dart';

class IncidentModel extends Incident {
  IncidentModel({
    String? id,
    required String title,
    required String description,
    required String location,
  }) : super(
    id: id,
    title: title,
    description: description,
    location: location,
  );

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      id: (json['_id'] ?? json['id'])?.toString(),
      title: json['title'],
      description: json['description'],
      location: json['location'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
    };
  }
}
