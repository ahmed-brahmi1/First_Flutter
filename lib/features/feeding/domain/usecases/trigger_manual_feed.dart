import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/feeding_repository.dart';

class TriggerManualFeed implements UseCase<void, NoParams> {
  final FeedingRepository repository;

  TriggerManualFeed(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.triggerManualFeed();
  }
}

