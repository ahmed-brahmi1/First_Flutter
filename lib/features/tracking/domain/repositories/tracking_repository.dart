import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../dashboard/domain/entities/location.dart';
import '../entities/geofence.dart';

abstract class TrackingRepository {
  Future<Either<Failure, Location>> getRealtimeLocation();
  Future<Either<Failure, Geofence>> setGeofence(Geofence geofence);
  Future<Either<Failure, List<Location>>> getLocationHistory(DateTime start, DateTime end);
}

