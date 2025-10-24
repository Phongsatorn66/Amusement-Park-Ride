import 'ride_status.dart';

class Ride {
  final int? id;
  final String name;
  final String imageUrl;
  final String description;
  final int thrillLevel; 
  final RideStatus status; 

  Ride({
    this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.thrillLevel, 
    required this.status, 
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'thrillLevel': thrillLevel, 
      'status': status.name, 
    };
  }

  factory Ride.fromMap(Map<String, dynamic> map) {
    return Ride(
      id: map['id'] as int?,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      description: map['description'] as String,
      thrillLevel: map['thrillLevel'] as int? ?? 3,
      status: RideStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => RideStatus.available, 
      ),
    );
  }
}