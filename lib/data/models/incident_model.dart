class Incident {
  final String id;
  final String title;
  final String description;
  final String location;

  Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'location': location,
      };
}
