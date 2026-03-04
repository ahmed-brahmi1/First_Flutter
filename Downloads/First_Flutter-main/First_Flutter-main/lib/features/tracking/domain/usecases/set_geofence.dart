import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/geofence.dart';
import '../repositories/tracking_repository.dart';

class SetGeofence implements UseCase<Geofence, SetGeofenceParams> {
  final TrackingRepository repository;

  SetGeofence(this.repository);

  @override
  Future<Either<Failure, Geofence>> call(SetGeofenceParams params) async {
    return await repository.setGeofence(params.geofence);
  }
}

class SetGeofenceParams {
  final Geofence geofence;

  SetGeofenceParams({required this.geofence});
}

