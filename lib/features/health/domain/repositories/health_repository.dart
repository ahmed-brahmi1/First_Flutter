import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/health_log.dart';

abstract class HealthRepository {
  Future<Either<Failure, List<HealthLog>>> getTemperatureHistory(DateTime start, DateTime end);
  Future<Either<Failure, Map<String, dynamic>>> getAIPredictions();
}

