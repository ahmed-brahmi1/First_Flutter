import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/health_log.dart';
import '../repositories/health_repository.dart';

class GetTemperatureHistory implements UseCase<List<HealthLog>, GetTemperatureHistoryParams> {
  final HealthRepository repository;

  GetTemperatureHistory(this.repository);

  @override
  Future<Either<Failure, List<HealthLog>>> call(GetTemperatureHistoryParams params) async {
    return await repository.getTemperatureHistory(params.start, params.end);
  }
}

class GetTemperatureHistoryParams {
  final DateTime start;
  final DateTime end;

  GetTemperatureHistoryParams({required this.start, required this.end});
}

