import 'package:dartz/dartz.dart';
import '../../../../config/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/pet_status.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/health_data.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_local_datasource.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../models/pet_status_model.dart';
import '../models/location_model.dart';
import '../models/health_data_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final DashboardLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PetStatus>> getPetStatus() async {
    // Use mock data in demo mode
    if (AppConstants.useDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      final mockStatus = PetStatusModel(
        id: 'demo_pet_1',
        isActive: true,
        batteryLevel: 0.85,
        lastUpdate: DateTime.now(),
      );
      await localDataSource.cachePetStatus(mockStatus);
      return Right(mockStatus);
    }
    
    if (await networkInfo.isConnected) {
      try {
        // TODO: Get token from secure storage
        const token = '';
        final status = await remoteDataSource.getPetStatus(token);
        await localDataSource.cachePetStatus(status);
        return Right(status);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        // Try to get cached data
        final cached = await localDataSource.getCachedPetStatus();
        if (cached != null) {
          return Right(cached);
        }
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      final cached = await localDataSource.getCachedPetStatus();
      if (cached != null) {
        return Right(cached);
      }
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Location>> getLocation() async {
    // Use mock data in demo mode
    if (AppConstants.useDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      final mockLocation = LocationModel(
        latitude: 37.7749, // San Francisco coordinates
        longitude: -122.4194,
        timestamp: DateTime.now(),
        accuracy: 10.0,
      );
      await localDataSource.cacheLocation(mockLocation);
      return Right(mockLocation);
    }
    
    if (await networkInfo.isConnected) {
      try {
        // TODO: Get token from secure storage
        const token = '';
        final location = await remoteDataSource.getLocation(token);
        await localDataSource.cacheLocation(location);
        return Right(location);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        final cached = await localDataSource.getCachedLocation();
        if (cached != null) {
          return Right(cached);
        }
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      final cached = await localDataSource.getCachedLocation();
      if (cached != null) {
        return Right(cached);
      }
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, HealthData>> getHealthData() async {
    // Use mock data in demo mode
    if (AppConstants.useDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      final mockHealthData = HealthDataModel(
        id: 'demo_health_1',
        temperature: 38.5,
        heartRate: 85,
        activityLevel: 60,
        timestamp: DateTime.now(),
      );
      await localDataSource.cacheHealthData(mockHealthData);
      return Right(mockHealthData);
    }
    
    if (await networkInfo.isConnected) {
      try {
        // TODO: Get token from secure storage
        const token = '';
        final healthData = await remoteDataSource.getHealthData(token);
        await localDataSource.cacheHealthData(healthData);
        return Right(healthData);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        final cached = await localDataSource.getCachedHealthData();
        if (cached != null) {
          return Right(cached);
        }
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      final cached = await localDataSource.getCachedHealthData();
      if (cached != null) {
        return Right(cached);
      }
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}

