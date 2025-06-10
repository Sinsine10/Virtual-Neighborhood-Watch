class Incident {
  final String? id;
  final String title;
  final String description;
  final String location;

  Incident({
    this.id,
    required this.title,
    required this.description,
    required this.location,
  });

  factory Incident.fromJson(Map<String, dynamic> json) => Incident(
    id: (json['_id'] ?? json['id'])?.toString(),
    title: json['title'],
    description: json['description'],
    location: json['location'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'location': location,
  };

  Incident copyWith({
    String? title,
    String? description,
    String? location,
  }) {
    return Incident(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
    );
  }
}
