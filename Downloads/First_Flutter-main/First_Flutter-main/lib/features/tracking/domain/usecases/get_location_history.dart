import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../dashboard/domain/entities/location.dart';
import '../repositories/tracking_repository.dart';

class GetLocationHistory implements UseCase<List<Location>, GetLocationHistoryParams> {
  final TrackingRepository repository;

  GetLocationHistory(this.repository);

  @override
  Future<Either<Failure, List<Location>>> call(GetLocationHistoryParams params) async {
    return await repository.getLocationHistory(params.start, params.end);
  }
}

class GetLocationHistoryParams {
  final DateTime start;
  final DateTime end;

  GetLocationHistoryParams({required this.start, required this.end});
}

