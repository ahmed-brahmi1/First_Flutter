import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/feeding_schedule.dart';
import '../repositories/feeding_repository.dart';

class SetSchedule implements UseCase<FeedingSchedule, SetScheduleParams> {
  final FeedingRepository repository;

  SetSchedule(this.repository);

  @override
  Future<Either<Failure, FeedingSchedule>> call(SetScheduleParams params) async {
    return await repository.setSchedule(params.schedule);
  }
}

class SetScheduleParams {
  final FeedingSchedule schedule;

  SetScheduleParams({required this.schedule});
}

