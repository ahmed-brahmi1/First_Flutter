import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/pet_status.dart';
import '../entities/location.dart';
import '../entities/health_data.dart';

abstract class DashboardRepository {
  Future<Either<Failure, PetStatus>> getPetStatus();
  Future<Either<Failure, Location>> getLocation();
  Future<Either<Failure, HealthData>> getHealthData();
}

