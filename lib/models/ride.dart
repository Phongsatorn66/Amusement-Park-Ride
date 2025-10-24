// lib/models/ride.dart
class Ride {
  final int? id;
  final String name;
  final String imageUrl;
  final String description;

  Ride({
    this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  factory Ride.fromMap(Map<String, dynamic> map) {
    return Ride(
      id: map['id'] as int?,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      description: map['description'] as String,
    );
  }
}
