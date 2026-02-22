import 'package:dartz/dartz.dart';
import '../../../../config/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/alert.dart';
import '../../domain/repositories/alert_repository.dart';
import '../datasources/alert_local_datasource.dart';
import '../datasources/alert_remote_datasource.dart';
import '../models/alert_model.dart';

class AlertRepositoryImpl implements AlertRepository {
  final AlertRemoteDataSource remoteDataSource;
  final AlertLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AlertRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Alert>>> getAlerts() async {
    // Use mock data in demo mode
    if (AppConstants.useDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      final mockAlerts = [
        AlertModel(
          id: 'alert_1',
          title: 'Feeding Reminder',
          message: 'Scheduled feeding time in 15 minutes',
          type: AlertType.feeding,
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          isRead: false,
        ),
        AlertModel(
          id: 'alert_2',
          title: 'Geofence Alert',
          message: 'Pet has left the safe zone',
          type: AlertType.geofence,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: false,
        ),
        AlertModel(
          id: 'alert_3',
          title: 'Battery Low',
          message: 'Device battery is at 20%',
          type: AlertType.battery,
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          isRead: true,
        ),
      ];
      await localDataSource.cacheAlerts(mockAlerts);
      return Right(mockAlerts);
    }
    
    if (await networkInfo.isConnected) {
      try {
        // TODO: Get token from secure storage
        const token = '';
        final alerts = await remoteDataSource.getAlerts(token);
        await localDataSource.cacheAlerts(alerts);
        return Right(alerts);
      } on ServerException catch (e) {
        // Try to get cached data
        final cached = await localDataSource.getCachedAlerts();
        if (cached.isNotEmpty) {
          return Right(cached);
        }
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        final cached = await localDataSource.getCachedAlerts();
        if (cached.isNotEmpty) {
          return Right(cached);
        }
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      final cached = await localDataSource.getCachedAlerts();
      if (cached.isNotEmpty) {
        return Right(cached);
      }
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> markAlertRead(String alertId) async {
    // Use mock data in demo mode
    if (AppConstants.useDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return const Right(null);
    }
    
    if (await networkInfo.isConnected) {
      try {
        // TODO: Get token from secure storage
        const token = '';
        await remoteDataSource.markAlertRead(token, alertId);
        return const Right(null);
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
  Future<Either<Failure, void>> subscribePushNotifications(String deviceToken) async {
    if (await networkInfo.isConnected) {
      try {
        // TODO: Get token from secure storage
        const token = '';
        await remoteDataSource.subscribePushNotifications(token, deviceToken);
        return const Right(null);
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

