import 'package:equatable/equatable.dart';

enum AlertType {
  geofence,
  health,
  feeding,
  battery,
  connection,
}

class Alert extends Equatable {
  final String id;
  final String title;
  final String message;
  final AlertType type;
  final DateTime timestamp;
  final bool isRead;

  const Alert({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
  });

  @override
  List<Object> get props => [id, title, message, type, timestamp, isRead];
}

