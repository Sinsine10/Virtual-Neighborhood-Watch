class Tip {
  final int id;
  final String description;

  Tip({required this.id, required this.description});

  // Factory constructor to create Tip from JSON
  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      id: json['id'] as int,
      description: json['description'] as String,
    );
  }

  // Convert Tip to JSON (for POST requests, if needed)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
    };
  }
}