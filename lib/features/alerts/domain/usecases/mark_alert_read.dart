import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/alert_repository.dart';

class MarkAlertRead implements UseCase<void, MarkAlertReadParams> {
  final AlertRepository repository;

  MarkAlertRead(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkAlertReadParams params) async {
    return await repository.markAlertRead(params.alertId);
  }
}

class MarkAlertReadParams {
  final String alertId;

  MarkAlertReadParams({required this.alertId});
}

