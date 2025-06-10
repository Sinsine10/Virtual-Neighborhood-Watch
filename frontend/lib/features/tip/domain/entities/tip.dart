class Tip {
  final int id;
  final String description;

  Tip({required this.id, required this.description});

  // Converts a Tip instance to a Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
    };
  }

  // Factory constructor for creating a Tip instance from a Map
  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      id: json['id'],
      description: json['description'],
    );
  }
}