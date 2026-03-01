import '../../domain/entities/pet_status.dart';

class PetStatusModel extends PetStatus {
  const PetStatusModel({
    required super.id,
    required super.isActive,
    required super.batteryLevel,
    required super.lastUpdate,
  });

  factory PetStatusModel.fromJson(Map<String, dynamic> json) {
    return PetStatusModel(
      id: json['id'] as String,
      isActive: json['is_active'] as bool,
      batteryLevel: (json['battery_level'] as num).toDouble(),
      lastUpdate: DateTime.parse(json['last_update'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_active': isActive,
      'battery_level': batteryLevel,
      'last_update': lastUpdate.toIso8601String(),
    };
  }
}

