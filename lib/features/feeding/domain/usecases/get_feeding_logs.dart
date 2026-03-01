import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/feeding_schedule.dart';
import '../repositories/feeding_repository.dart';

class GetFeedingLogs implements UseCase<List<FeedingSchedule>, NoParams> {
  final FeedingRepository repository;

  GetFeedingLogs(this.repository);

  @override
  Future<Either<Failure, List<FeedingSchedule>>> call(NoParams params) async {
    return await repository.getFeedingLogs();
  }
}

