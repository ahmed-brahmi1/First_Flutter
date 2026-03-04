import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/health_repository.dart';

class GetAIPredictions implements UseCase<Map<String, dynamic>, NoParams> {
  final HealthRepository repository;

  GetAIPredictions(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) async {
    return await repository.getAIPredictions();
  }
}

