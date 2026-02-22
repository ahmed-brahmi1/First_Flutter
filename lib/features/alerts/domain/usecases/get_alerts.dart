import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/alert.dart';
import '../repositories/alert_repository.dart';

class GetAlerts implements UseCase<List<Alert>, NoParams> {
  final AlertRepository repository;

  GetAlerts(this.repository);

  @override
  Future<Either<Failure, List<Alert>>> call(NoParams params) async {
    return await repository.getAlerts();
  }
}

