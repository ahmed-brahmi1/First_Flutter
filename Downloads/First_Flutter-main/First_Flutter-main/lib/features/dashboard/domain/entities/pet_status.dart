import 'package:equatable/equatable.dart';

class PetStatus extends Equatable {
  final String id;
  final bool isActive;
  final double batteryLevel;
  final DateTime lastUpdate;

  const PetStatus({
    required this.id,
    required this.isActive,
    required this.batteryLevel,
    required this.lastUpdate,
  });

  @override
  List<Object> get props => [id, isActive, batteryLevel, lastUpdate];
}

