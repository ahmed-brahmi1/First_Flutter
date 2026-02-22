import 'package:dartz/dartz.dart';
import '../../../../config/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/health_log.dart';
import '../../domain/repositories/health_repository.dart';
import '../datasources/health_remote_datasource.dart';
import '../models/health_log_model.dart';

class HealthRepositoryImpl implements HealthRepository {
  final HealthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  HealthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<HealthLog>>> getTemperatureHistory(
    DateTime start,
    DateTime end,
  ) async {
    // Use mock data in demo mode
    if (AppConstants.useDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      final mockLogs = List.generate(7, (index) {
        return HealthLogModel(
          id: 'health_log_$index',
          temperature: 38.0 + (index * 0.1),
          heartRate: 80 + index,
          activityLevel: 50 + (index * 5),
          timestamp: DateTime.now().subtract(Duration(days: 6 - index)),
        );
      });
      return Right(mockLogs);
    }
    
    if (await networkInfo.isConnected) {
      try {
        // TODO: Get token from secure storage
        const token = '';
        final logs = await remoteDataSource.getTemperatureHistory(token, start, end);
        return Right(logs);
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
  Future<Either<Failure, Map<String, dynamic>>> getAIPredictions() async {
    // Use mock data in demo mode
    if (AppConstants.useDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      final mockPredictions = {
        'prediction': 'Your pet\'s health metrics are within normal range. Temperature and activity levels are stable.',
        'confidence': 0.92,
        'recommendations': [
          'Continue current feeding schedule',
          'Monitor activity levels',
          'Regular exercise recommended'
        ],
      };
      return Right(mockPredictions);
    }
    
    if (await networkInfo.isConnected) {
      try {
        // TODO: Get token from secure storage
        const token = '';
        final predictions = await remoteDataSource.getAIPredictions(token);
        return Right(predictions);
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

