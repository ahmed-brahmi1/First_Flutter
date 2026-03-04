import 'package:dartz/dartz.dart';
import '../../../../config/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/feeding_schedule.dart';
import '../../domain/repositories/feeding_repository.dart';
import '../datasources/feeding_remote_datasource.dart';
import '../models/feeding_schedule_model.dart';

class FeedingRepositoryImpl implements FeedingRepository {
  final FeedingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FeedingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<FeedingSchedule>>> getFeedingLogs() async {
    // Use mock data in demo mode
    if (AppConstants.useDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      final mockSchedules = [
        FeedingScheduleModel(
          id: 'schedule_1',
          time: DateTime(2024, 1, 1, 8, 0), // 8:00 AM
          amount: 100.0,
          isActive: true,
          daysOfWeek: [1, 2, 3, 4, 5], // Monday to Friday
        ),
        FeedingScheduleModel(
          id: 'schedule_2',
          time: DateTime(2024, 1, 1, 18, 0), // 6:00 PM
          amount: 150.0,
          isActive: true,
          daysOfWeek: [1, 2, 3, 4, 5, 6, 7], // Every day
        ),
      ];
      return Right(mockSchedules);
    }
    
    if (await networkInfo.isConnected) {
      try {
        // TODO: Get token from secure storage
        const token = '';
        final logs = await remoteDataSource.getFeedingLogs(token);
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
  Future<Either<Failure, void>> triggerManualFeed() async {
    // Use mock data in demo mode
    if (AppConstants.useDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return const Right(null);
    }
    
    if (await networkInfo.isConnected) {
      try {
        // TODO: Get token from secure storage
        const token = '';
        await remoteDataSource.triggerManualFeed(token);
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
  Future<Either<Failure, FeedingSchedule>> setSchedule(
    FeedingSchedule schedule,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        // TODO: Get token from secure storage
        const token = '';
        final scheduleModel = FeedingScheduleModel(
          id: schedule.id,
          time: schedule.time,
          amount: schedule.amount,
          isActive: schedule.isActive,
          daysOfWeek: schedule.daysOfWeek,
        );
        final result = await remoteDataSource.setSchedule(token, scheduleModel);
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
}

