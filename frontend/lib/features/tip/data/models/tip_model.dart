import '../../domain/entities/tip.dart';

class TipModel extends Tip {
  TipModel({required int id, required String description})
      : super(id: id, description: description);

  factory TipModel.fromJson(Map<String, dynamic> json) {
    return TipModel(
      id: json['id'], // Ensure this is parsed as an int
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
    };
  }
}