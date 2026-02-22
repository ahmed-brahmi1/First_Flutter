import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/health_log.dart';
import 'package:smartpet/features/data/models/sensor_model.dart';

abstract class HealthRepository {
  Future<Either<Failure, List<HealthLog>>> getTemperatureHistory(DateTime start, DateTime end);
  Future<Either<Failure, Map<String, dynamic>>> getAIPredictions();
Future<SensorModel> getLatestSensor();
}

