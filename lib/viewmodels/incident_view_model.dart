class Incident {
  final String title;
  final String description;
  final String location;

  Incident({
    required this.title,
    required this.description,
    required this.location,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      title: json['title'],
      description: json['description'],
      location: json['location'],
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
