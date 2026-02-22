import 'package:equatable/equatable.dart';
import '../../domain/entities/pet_status.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/health_data.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final PetStatus petStatus;
  final Location location;
  final HealthData healthData;

  const DashboardLoaded({
    required this.petStatus,
    required this.location,
    required this.healthData,
  });

  @override
  List<Object?> get props => [petStatus, location, healthData];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

