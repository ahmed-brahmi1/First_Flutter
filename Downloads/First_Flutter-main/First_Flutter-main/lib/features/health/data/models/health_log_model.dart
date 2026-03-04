import '../../domain/entities/health_log.dart';

class HealthLogModel extends HealthLog {
  const HealthLogModel({
    required super.id,
    required super.temperature,
    required super.heartRate,
    required super.activityLevel,
    required super.timestamp,
    super.notes,
  });

  factory HealthLogModel.fromJson(Map<String, dynamic> json) {
    return HealthLogModel(
      id: json['id'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      heartRate: json['heart_rate'] as int,
      activityLevel: json['activity_level'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'temperature': temperature,
      'heart_rate': heartRate,
      'activity_level': activityLevel,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }
}

