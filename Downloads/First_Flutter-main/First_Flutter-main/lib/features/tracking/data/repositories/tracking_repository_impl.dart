import 'package:dartz/dartz.dart';
import '../../../../config/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../dashboard/domain/entities/location.dart';
import '../../../dashboard/data/models/location_model.dart';
import '../../domain/entities/geofence.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../datasources/tracking_remote_datasource.dart';
import '../models/geofence_model.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TrackingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Location>> getRealtimeLocation() async {
    // Use mock data in demo mode
    if (AppConstants.useDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      final mockLocation = LocationModel(
        latitude: 37.7749,
        longitude: -122.4194,
        timestamp: DateTime.now(),
        accuracy: 10.0,
      );
      return Right(mockLocation);
    }
    
    if (await networkInfo.isConnected) {
      try {
        // TODO: Get token from secure storage
        const token = '';
        final location = await remoteDataSource.getRealtimeLocation(token);
        return Right(location);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Geofence>> setGeofence(Geofence geofence) async {
    if (await networkInfo.isConnected) {
      try {
        // TODO: Get token from secure storage
        const token = '';
        final geofenceModel = GeofenceModel(
          id: geofence.id,
          latitude: geofence.latitude,
          longitude: geofence.longitude,
          radius: geofence.radius,
          name: geofence.name,
          isActive: geofence.isActive,
        );
        final result = await remoteDataSource.setGeofence(token, geofenceModel);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Location>>> getLocationHistory(
    DateTime start,
    DateTime end,
  ) async {
    // Use mock data in demo mode
    if (AppConstants.useDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      final mockLocations = List.generate(10, (index) {
        return LocationModel(
          latitude: 37.7749 + (index * 0.001),
          longitude: -122.4194 + (index * 0.001),
          timestamp: DateTime.now().subtract(Duration(hours: index)),
          accuracy: 10.0,
        );
      });
      return Right(mockLocations);
    }
    
    if (await networkInfo.isConnected) {
      try {
        // TODO: Get token from secure storage
        const token = '';
        final locations = await remoteDataSource.getLocationHistory(token, start, end);
        return Right(locations);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}

