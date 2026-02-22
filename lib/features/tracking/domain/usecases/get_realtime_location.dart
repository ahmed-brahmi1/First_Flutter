import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../dashboard/domain/entities/location.dart';
import '../repositories/tracking_repository.dart';

class GetRealtimeLocation implements UseCase<Location, NoParams> {
  final TrackingRepository repository;

  GetRealtimeLocation(this.repository);

  @override
  Future<Either<Failure, Location>> call(NoParams params) async {
    return await repository.getRealtimeLocation();
  }
}

