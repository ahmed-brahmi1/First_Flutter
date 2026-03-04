import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/feeding_schedule.dart';

abstract class FeedingRepository {
  Future<Either<Failure, List<FeedingSchedule>>> getFeedingLogs();
  Future<Either<Failure, void>> triggerManualFeed();
  Future<Either<Failure, FeedingSchedule>> setSchedule(FeedingSchedule schedule);
}

