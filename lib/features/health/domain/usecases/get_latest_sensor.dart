import 'package:smartpet/features/data/models/sensor_model.dart';
import 'package:smartpet/features/health/domain/repositories/health_repository.dart';

class GetLatestSensor {
  final HealthRepository repository;

  GetLatestSensor(this.repository);

  Future<SensorModel> call() {
    return repository.getLatestSensor();
  }
}