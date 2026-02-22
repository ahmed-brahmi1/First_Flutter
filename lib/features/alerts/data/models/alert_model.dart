import '../../domain/entities/alert.dart';

class AlertModel extends Alert {
  const AlertModel({
    required super.id,
    required super.title,
    required super.message,
    required super.type,
    required super.timestamp,
    required super.isRead,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: _parseAlertType(json['type'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['is_read'] as bool,
    );
  }

  static AlertType _parseAlertType(String type) {
    switch (type.toLowerCase()) {
      case 'geofence':
        return AlertType.geofence;
      case 'health':
        return AlertType.health;
      case 'feeding':
        return AlertType.feeding;
      case 'battery':
        return AlertType.battery;
      case 'connection':
        return AlertType.connection;
      default:
        return AlertType.health;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
    };
  }
}

