import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/health_data.dart';
import '../repositories/dashboard_repository.dart';

class GetHealthData implements UseCase<HealthData, NoParams> {
  final DashboardRepository repository;

  GetHealthData(this.repository);

  @override
  Future<Either<Failure, HealthData>> call(NoParams params) async {
    return await repository.getHealthData();
  }
}

